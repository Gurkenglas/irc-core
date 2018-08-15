{-# Language GeneralizedNewtypeDeriving, RankNTypes, RecordWildCards #-}
{-|
Module      : Client.CApi
Description : Dynamically loaded extension API
Copyright   : (c) Eric Mertens, 2016
License     : ISC
Maintainer  : emertens@gmail.com

Foreign interface to the IRC client via a simple C API
and dynamically loaded modules.

-}

module Client.CApi
  ( -- * Extension type
    ActiveExtension(..)

  -- * Extension callbacks
  , extensionSymbol
  , openExtension
  , startExtension
  , deactivateExtension
  , notifyExtension
  , commandExtension
  , chatExtension

  , popTimer
  , pushTimer

  , evalNestedIO
  , withChat
  , withRawIrcMsg
  ) where

import           Client.Configuration
                   (ExtensionConfiguration,
                    extensionPath, extensionRtldFlags, extensionArgs)
import           Client.CApi.Types
import           Control.Lens (view)
import           Control.Monad
import           Control.Monad.IO.Class
import           Control.Monad.Codensity
import           Data.Map (Map)
import qualified Data.Map as Map
import           Data.Text (Text)
import qualified Data.Text as Text
import           Data.List.NonEmpty (NonEmpty(..), nonEmpty)
import           Data.Time
import           Foreign.C
import           Foreign.Marshal
import           Foreign.Ptr
import           Foreign.Storable
import           Irc.Identifier
import           Irc.RawIrcMsg
import           Irc.UserInfo
import           System.Posix.DynamicLinker

------------------------------------------------------------------------

-- | The symbol that is loaded from an extension object.
--
-- Extensions are expected to export:
--
-- @
-- struct galua_extension extension;
-- @
extensionSymbol :: String
extensionSymbol = "extension"

-- | Information about a loaded extension including the handle
-- to the loaded shared object, and state value returned by
-- the startup callback, and the loaded extension record.
data ActiveExtension = ActiveExtension
  { aeFgn     :: !FgnExtension -- ^ Struct of callback function pointers
  , aeDL      :: !DL           -- ^ Handle of dynamically linked extension
  , aeSession :: !(Ptr ())       -- ^ State value generated by start callback
  , aeName    :: !Text
  , aeMajorVersion, aeMinorVersion :: !Int
  , aeTimers  :: !(Map UTCTime (NonEmpty (FunPtr TimerCallback, Ptr ())))
  }

popTimer ::
  ActiveExtension ->
  Maybe (UTCTime, FunPtr TimerCallback, Ptr (), ActiveExtension)
popTimer ae =
  do let timers = aeTimers ae
     ((time, (fun, ptr) :| rest), timers') <- Map.minViewWithKey timers
     let ae' = ae { aeTimers = case nonEmpty rest of
                                 Nothing -> timers'
                                 Just rest' -> Map.insert time rest' timers
                  }
     return (time, fun, ptr, ae')

pushTimer ::
  UTCTime ->
  FunPtr TimerCallback ->
  Ptr () ->
  ActiveExtension ->
  ActiveExtension
pushTimer time fun ptr ae = ae { aeTimers = Map.alter aux time (aeTimers ae) }
  where
    aux Nothing = Just ((fun,ptr) :| [])
    aux (Just (x :| xs)) = Just ((fun,ptr) :| x : xs)

-- | Load the extension from the given path and call the start
-- callback. The result of the start callback is saved to be
-- passed to any subsequent calls into the extension.
openExtension ::
  ExtensionConfiguration {- ^ extension configuration -} ->
  IO ActiveExtension
openExtension config =
  do dl   <- dlopen (view extensionPath config)
                    (view extensionRtldFlags config)
     p    <- dlsym dl extensionSymbol
     fgn  <- peek (castFunPtrToPtr p)
     name <- peekCString (fgnName fgn)
     return $! ActiveExtension
       { aeFgn          = fgn
       , aeDL           = dl
       , aeSession      = nullPtr
       , aeName         = Text.pack name
       , aeTimers       = Map.empty
       , aeMajorVersion = fromIntegral (fgnMajorVersion fgn)
       , aeMinorVersion = fromIntegral (fgnMinorVersion fgn)
       }

startExtension ::
  Ptr ()                 {- ^ client stable pointer   -} ->
  ExtensionConfiguration {- ^ extension configuration -} ->
  ActiveExtension        {- ^ active extension        -} ->
  IO (Ptr ())            {- ^ extension state         -}
startExtension stab config ae =
  do let f = fgnStart (aeFgn ae)
     if nullFunPtr == f
       then return nullPtr
       else evalNestedIO $
                  do extPath <- nest1 (withCString (view extensionPath config))
                     args <- traverse withText
                           $ view extensionArgs config
                     argsArray <- nest1 (withArray args)
                     let len = fromIntegral (length args)
                     liftIO (runStartExtension f stab extPath argsArray len)

-- | Call the stop callback of the extension if it is defined
-- and unload the shared object.
deactivateExtension :: Ptr () -> ActiveExtension -> IO ()
deactivateExtension stab ae =
  do let f = fgnStop (aeFgn ae)
     unless (nullFunPtr == f) $
       runStopExtension f stab (aeSession ae)
     dlclose (aeDL ae)


-- | Call all of the process chat callbacks in the list of extensions.
-- This operation marshals the IRC message once and shares that across
-- all of the callbacks.
--
-- Returns 'True' to pass message to client.  Returns 'False to drop message.
chatExtension ::
  Ptr ()          {- ^ client callback handle  -} ->
  ActiveExtension {- ^ extension               -} ->
  Ptr FgnChat     {- ^ serialized chat message -} ->
  IO Bool         {- ^ allow message           -}
chatExtension stab ae chat =
  do let f = fgnChat (aeFgn ae)
     if f == nullFunPtr
       then return True
       else (passMessage ==) <$> runProcessChat f stab (aeSession ae) chat

-- | Call all of the process message callbacks in the list of extensions.
-- This operation marshals the IRC message once and shares that across
-- all of the callbacks.
--
-- Returns 'True' to pass message to client.  Returns 'False to drop message.
notifyExtension ::
  Ptr ()          {- ^ clientstate stable pointer -} ->
  ActiveExtension {- ^ extension                  -} ->
  Ptr FgnMsg      {- ^ serialized IRC message     -} ->
  IO Bool         {- ^ allow message              -}
notifyExtension stab ae msg =
  do let f = fgnMessage (aeFgn ae)
     if f == nullFunPtr
       then return True
       else (passMessage ==) <$> runProcessMessage f stab (aeSession ae) msg


-- | Notify an extension of a client command with the given parameters.
commandExtension ::
  Ptr ()          {- ^ client state stableptr -} ->
  Text            {- ^ command                -} ->
  ActiveExtension {- ^ extension to command   -} ->
  IO ()
commandExtension stab command ae = evalNestedIO $
  do cmd <- withCommand command
     let f = fgnCommand (aeFgn ae)
     liftIO $ unless (f == nullFunPtr)
            $ runProcessCommand f stab (aeSession ae) cmd

-- | Marshal a 'RawIrcMsg' into a 'FgnMsg' which will be valid for
-- the remainder of the computation.
withRawIrcMsg ::
  Text                 {- ^ network      -} ->
  RawIrcMsg            {- ^ message      -} ->
  NestedIO (Ptr FgnMsg)
withRawIrcMsg network RawIrcMsg{..} =
  do net     <- withText network
     pfxN    <- withText $ maybe Text.empty (idText.userNick) _msgPrefix
     pfxU    <- withText $ maybe Text.empty userName _msgPrefix
     pfxH    <- withText $ maybe Text.empty userHost _msgPrefix
     cmd     <- withText _msgCommand
     prms    <- traverse withText _msgParams
     tags    <- traverse withTag  _msgTags
     let (keys,vals) = unzip tags
     (tagN,keysPtr) <- nest2 $ withArrayLen keys
     valsPtr        <- nest1 $ withArray vals
     (prmN,prmPtr)  <- nest2 $ withArrayLen prms
     nest1 $ with $ FgnMsg net pfxN pfxU pfxH cmd prmPtr (fromIntegral prmN)
                                       keysPtr valsPtr (fromIntegral tagN)

withChat ::
  Text {- ^ network -} ->
  Text {- ^ target  -} ->
  Text {- ^ message -} ->
  NestedIO (Ptr FgnChat)
withChat net tgt msg =
  do net' <- withText net
     tgt' <- withText tgt
     msg' <- withText msg
     nest1 $ with $ FgnChat net' tgt' msg'

withCommand ::
  Text {- ^ command -} ->
  NestedIO (Ptr FgnCmd)
withCommand command =
  do cmd <- withText command
     nest1 $ with $ FgnCmd cmd

withTag :: TagEntry -> NestedIO (FgnStringLen, FgnStringLen)
withTag (TagEntry k v) =
  do pk <- withText k
     pv <- withText v
     return (pk,pv)

withText :: Text -> NestedIO FgnStringLen
withText txt =
  do (ptr,len) <- nest1 $ withText0 txt
     return $ FgnStringLen ptr $ fromIntegral len

------------------------------------------------------------------------

-- | Continuation-passing style bracked IO actions.
newtype NestedIO a = NestedIO (Codensity IO a)
  deriving (Functor, Applicative, Monad, MonadIO)

-- | Return the bracket IO action.
evalNestedIO :: NestedIO a -> IO a
evalNestedIO (NestedIO m) = lowerCodensity m

-- | Wrap up a bracketing IO operation where the continuation takes 1 argument
nest1 :: (forall r. (a -> IO r) -> IO r) -> NestedIO a
nest1 f = NestedIO (Codensity f)

-- | Wrap up a bracketing IO operation where the continuation takes 2 argument
nest2 :: (forall r. (a -> b -> IO r) -> IO r) -> NestedIO (a,b)
nest2 f = NestedIO (Codensity (f . curry))

{-# Language OverloadedStrings #-}
{-|
Module      : Irc.Commands
Description : Smart constructors for 'RawIrcMsg'
Copyright   : (c) Eric Mertens, 2016
License     : ISC
Maintainer  : emertens@gmail.com

This module provides smart constructors for IRC commands.
-}
module Irc.Commands
  ( ircCapEnd
  , ircCapLs
  , ircCapReq
  , ircInvite
  , ircJoin
  , ircKick
  , ircMode
  , ircNick
  , ircPart
  , ircPass
  , ircPong
  , ircPrivmsg
  , ircNotice
  , ircQuit
  , ircRemove
  , ircTopic
  , ircUser
  , ircWho
  , ircWhois
  , ircWhowas
  , ircIson
  , ircUserhost
  , ircAway

  -- * SASL support
  , ircAuthenticate
  , plainAuthenticationMode
  , encodePlainAuthentication
  ) where

import           Irc.RawIrcMsg
import           Irc.Identifier
import           Data.Text (Text)
import qualified Data.Text as Text
import qualified Data.Text.Encoding as Text
import qualified Data.ByteArray.Encoding as Enc

-- | PRIVMSG command
ircPrivmsg ::
  Identifier {- ^ target  -} ->
  Text       {- ^ message -} ->
  RawIrcMsg
ircPrivmsg who msg = rawIrcMsg "PRIVMSG" [idText who, msg]

-- | NOTICE command
ircNotice ::
  Identifier {- ^ target  -} ->
  Text       {- ^ message -} ->
  RawIrcMsg
ircNotice who msg = rawIrcMsg "NOTICE" [idText who, msg]

-- | MODE command
ircMode ::
  Identifier {- ^ target     -} ->
  [Text]     {- ^ parameters -} ->
  RawIrcMsg
ircMode tgt params = rawIrcMsg "MODE" (idText tgt : params)

-- | WHOIS command
ircWhois ::
  [Text] {- ^ parameters -} ->
  RawIrcMsg
ircWhois = rawIrcMsg "WHOIS"

-- | WHO command
ircWho ::
  [Text] {- ^ parameters -} ->
  RawIrcMsg
ircWho = rawIrcMsg "WHO"

-- | WHOWAS command
ircWhowas ::
  [Text] {- ^ parameters -} ->
  RawIrcMsg
ircWhowas = rawIrcMsg "WHOWAS"

-- | NICK command
ircNick ::
  Identifier {- ^ nickname -} ->
  RawIrcMsg
ircNick nick = rawIrcMsg "NICK" [idText nick]

-- | PART command
ircPart ::
  Identifier {- ^ channel -} ->
  Text       {- ^ message -} ->
  RawIrcMsg
ircPart chan msg
  | Text.null msg = rawIrcMsg "PART" [idText chan]
  | otherwise     = rawIrcMsg "PART" [idText chan, msg]

-- | JOIN command
ircJoin ::
  Text       {- ^ channel -} ->
  Maybe Text {- ^ key     -} ->
  RawIrcMsg
ircJoin chan (Just key) = rawIrcMsg "JOIN" [chan, key]
ircJoin chan Nothing    = rawIrcMsg "JOIN" [chan]

-- | INVITE command
ircInvite ::
  Text       {- ^ nickname -} ->
  Identifier {- ^ channel  -} ->
  RawIrcMsg
ircInvite nick channel = rawIrcMsg "INVITE" [nick, idText channel]

-- | TOPIC command
ircTopic ::
  Identifier {- ^ channel -} ->
  Text       {- ^ topic   -} ->
  RawIrcMsg
ircTopic chan msg
  | Text.null msg = rawIrcMsg "TOPIC" [idText chan]
  | otherwise     = rawIrcMsg "TOPIC" [idText chan, msg]

-- | KICK command
ircKick ::
  Identifier {- ^ channel  -} ->
  Text       {- ^ nickname -} ->
  Text       {- ^ message  -} ->
  RawIrcMsg
ircKick chan who msg
  | Text.null msg = rawIrcMsg "KICK" [idText chan, who]
  | otherwise     = rawIrcMsg "KICK" [idText chan, who, msg]

-- | REMOVE command
ircRemove ::
  Identifier {- ^ channel  -} ->
  Text       {- ^ nickname -} ->
  Text       {- ^ message  -} ->
  RawIrcMsg
ircRemove chan who msg
  | Text.null msg = rawIrcMsg "REMOVE" [idText chan, who]
  | otherwise     = rawIrcMsg "REMOVE" [idText chan, who, msg]

-- | QUIT command
ircQuit :: Text {- ^ quit message -} -> RawIrcMsg
ircQuit msg
  | Text.null msg = rawIrcMsg "QUIT" []
  | otherwise     = rawIrcMsg "QUIT" [msg]

-- | PASS command
ircPass :: Text {- ^ password -} -> RawIrcMsg
ircPass pass = rawIrcMsg "PASS" [pass]

-- | PONG command
ircPong ::
  [Text] {- ^ parameters -} ->
  RawIrcMsg
ircPong = rawIrcMsg "PONG"

-- | ISON command
ircIson ::
  [Text] {- ^ parameters -} ->
  RawIrcMsg
ircIson = rawIrcMsg "ISON"

-- | USERHOST command
ircUserhost ::
  [Text] {- ^ parameters -} ->
  RawIrcMsg
ircUserhost = rawIrcMsg "USERHOST"

-- | AWAY command
ircAway ::
  Text {- ^ message -} ->
  RawIrcMsg
ircAway msg
  | Text.null msg = rawIrcMsg "AWAY" []
  | otherwise     = rawIrcMsg "AWAY" [msg]

ircUser ::
  Text {- ^ username -} ->
  Bool {- ^ set +w   -} ->
  Bool {- ^ set +i   -} ->
  Text {- ^ realname -} -> RawIrcMsg
ircUser user set_w set_i real = rawIrcMsg "USER" [user, modeTxt, "*", real]
  where
    modeTxt = Text.pack (show mode)
    mode :: Int
    mode = (if set_w then 4 else 0) -- bit 2
         + (if set_i then 8 else 0) -- bit 3

-- | CAP REQ command
ircCapReq ::
  [Text] {- ^ capabilities -} ->
  RawIrcMsg
ircCapReq caps = rawIrcMsg "CAP" ["REQ", Text.unwords caps]

-- | CAP END command
ircCapEnd :: RawIrcMsg
ircCapEnd = rawIrcMsg "CAP" ["END"]

-- | CAP LS command
ircCapLs :: RawIrcMsg
ircCapLs = rawIrcMsg "CAP" ["LS"]

ircAuthenticate :: Text -> RawIrcMsg
ircAuthenticate msg = rawIrcMsg "AUTHENTICATE" [msg]

plainAuthenticationMode :: Text
plainAuthenticationMode = "PLAIN"

encodePlainAuthentication ::
  Text {- ^ username -} ->
  Text {- ^ password -} ->
  Text
encodePlainAuthentication user pass
  = Text.decodeUtf8
  $ Enc.convertToBase Enc.Base64
  $ Text.encodeUtf8
  $ Text.intercalate "\0" [user,user,pass]

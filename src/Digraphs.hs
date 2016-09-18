{-# Language OverloadedStrings #-}
{-|
Module      : Digraphs
Description : Character mnemonics
Copyright   : (c) Eric Mertens, 2016
License     : ISC
Maintainer  : emertens@gmail.com

This module provides an implementation of /digraphs/ as implemented
in Vim and as specified in RFC 1345 (2-character only).

<https://tools.ietf.org/html/rfc1345>
<http://vimdoc.sourceforge.net/htmldoc/digraph.html>

-}



module Digraphs (lookupDigraph) where

import           Data.ByteString.Short (ShortByteString)
import qualified Data.ByteString.Short as ByteString
import           Data.HashMap.Lazy (HashMap)
import qualified Data.HashMap.Lazy as HashMap
import           Data.String
import           Data.Char


-- | Look up 2-character digraph.
lookupDigraph :: Char -> Char -> Maybe Char
lookupDigraph x y
  | isAscii x, isAscii y = HashMap.lookup (fromString [x,y]) digraphs
  | otherwise            = Nothing


digraphs :: HashMap ShortByteString Char
digraphs = HashMap.fromList
  [ ("NU", '\x00')      -- NULL (NUL)
  , ("SH", '\x01')      -- START OF HEADING (SOH)
  , ("SX", '\x02')      -- START OF TEXT (STX)
  , ("EX", '\x03')      -- END OF TEXT (ETX)
  , ("ET", '\x04')      -- END OF TRANSMISSION (EOT)
  , ("EQ", '\x05')      -- ENQUIRY (ENQ)
  , ("AK", '\x06')      -- ACKNOWLEDGE (ACK)
  , ("BL", '\x07')      -- BELL (BEL)
  , ("BS", '\x08')      -- BACKSPACE (BS)
  , ("HT", '\x09')      -- CHARACTER TABULATION (HT)
--  , ("LF", '\x0a')    -- LINE FEED (LF)
  , ("VT", '\x0b')      -- LINE TABULATION (VT)
  , ("FF", '\x0c')      -- FORM FEED (FF)
--  , ("CR", '\x0d')    -- CARRIAGE RETURN (CR)
  , ("SO", '\x0e')      -- SHIFT OUT (SO)
  , ("SI", '\x0f')      -- SHIFT IN (SI)
  , ("DL", '\x10')      -- DATALINK ESCAPE (DLE)
  , ("D1", '\x11')      -- DEVICE CONTROL ONE (DC1)
  , ("D2", '\x12')      -- DEVICE CONTROL TWO (DC2)
  , ("D3", '\x13')      -- DEVICE CONTROL THREE (DC3)
  , ("D4", '\x14')      -- DEVICE CONTROL FOUR (DC4)
  , ("NK", '\x15')      -- NEGATIVE ACKNOWLEDGE (NAK)
  , ("SY", '\x16')      -- SYNCHRONOUS IDLE (SYN)
  , ("EB", '\x17')      -- END OF TRANSMISSION BLOCK (ETB)
  , ("CN", '\x18')      -- CANCEL (CAN)
  , ("EM", '\x19')      -- END OF MEDIUM (EM)
  , ("SB", '\x1a')      -- SUBSTITUTE (SUB)
  , ("EC", '\x1b')      -- ESCAPE (ESC)
  , ("FS", '\x1c')      -- FILE SEPARATOR (IS4)
  , ("GS", '\x1d')      -- GROUP SEPARATOR (IS3)
  , ("RS", '\x1e')      -- RECORD SEPARATOR (IS2)
  , ("US", '\x1f')      -- UNIT SEPARATOR (IS1)
  , ("SP", '\x20')      -- SPACE
  , ("Nb", '\x23')      -- NUMBER SIGN
  , ("DO", '\x24')      -- DOLLAR SIGN
  , ("At", '\x40')      -- COMMERCIAL AT
  , ("<(", '\x5b')      -- LEFT SQUARE BRACKET
  , ("//", '\x5c')      -- REVERSE SOLIDUS
  , (")>", '\x5d')      -- RIGHT SQUARE BRACKET
  , ("'>", '\x5e')      -- CIRCUMFLEX ACCENT
  , ("'!", '\x60')      -- GRAVE ACCENT
  , ("(!", '\x7b')      -- LEFT CURLY BRACKET
  , ("!!", '\x7c')      -- VERTICAL LINE
  , ("!)", '\x7d')      -- RIGHT CURLY BRACKET
  , ("'?", '\x7e')      -- TILDE
  , ("DT", '\x7f')      -- DELETE (DEL)
  , ("PA", '\x80')      -- PADDING CHARACTER (PAD)
  , ("HO", '\x81')      -- HIGH OCTET PRESET (HOP)
  , ("BH", '\x82')      -- BREAK PERMITTED HERE (BPH)
  , ("NH", '\x83')      -- NO BREAK HERE (NBH)
  , ("IN", '\x84')      -- INDEX (IND)
  , ("NL", '\x85')      -- NEXT LINE (NEL)
  , ("SA", '\x86')      -- START OF SELECTED AREA (SSA)
  , ("ES", '\x87')      -- END OF SELECTED AREA (ESA)
  , ("HS", '\x88')      -- CHARACTER TABULATION SET (HTS)
  , ("HJ", '\x89')      -- CHARACTER TABULATION WITH JUSTIFICATION (HTJ)
  , ("VS", '\x8a')      -- LINE TABULATION SET (VTS)
  , ("PD", '\x8b')      -- PARTIAL LINE FORWARD (PLD)
  , ("PU", '\x8c')      -- PARTIAL LINE BACKWARD (PLU)
  , ("RI", '\x8d')      -- REVERSE LINE FEED (RI)
  , ("S2", '\x8e')      -- SINGLE-SHIFT TWO (SS2)
  , ("S3", '\x8f')      -- SINGLE-SHIFT THREE (SS3)
  , ("DC", '\x90')      -- DEVICE CONTROL STRING (DCS)
  , ("P1", '\x91')      -- PRIVATE USE ONE (PU1)
  , ("P2", '\x92')      -- PRIVATE USE TWO (PU2)
  , ("TS", '\x93')      -- SET TRANSMIT STATE (STS)
  , ("CC", '\x94')      -- CANCEL CHARACTER (CCH)
  , ("MW", '\x95')      -- MESSAGE WAITING (MW)
  , ("SG", '\x96')      -- START OF GUARDED AREA (SPA)
  , ("EG", '\x97')      -- END OF GUARDED AREA (EPA)
  , ("SS", '\x98')      -- START OF STRING (SOS)
  , ("GC", '\x99')      -- SINGLE GRAPHIC CHARACTER INTRODUCER (SGCI)
  , ("SC", '\x9a')      -- SINGLE CHARACTER INTRODUCER (SCI)
  , ("CI", '\x9b')      -- CONTROL SEQUENCE INTRODUCER (CSI)
  , ("ST", '\x9c')      -- STRING TERMINATOR (ST)
  , ("OC", '\x9d')      -- OPERATING SYSTEM COMMAND (OSC)
  , ("PM", '\x9e')      -- PRIVACY MESSAGE (PM)
  , ("AC", '\x9f')      -- APPLICATION PROGRAM COMMAND (APC)
  , ("NS", '\xa0')      -- NO-BREAK SPACE
  , ("!I", '\xa1')      -- INVERTED EXCLAMATION MARK
  , ("Ct", '\xa2')      -- CENT SIGN
  , ("Pd", '\xa3')      -- POUND SIGN
  , ("Cu", '\xa4')      -- CURRENCY SIGN
  , ("Ye", '\xa5')      -- YEN SIGN
  , ("BB", '\xa6')      -- BROKEN BAR
  , ("SE", '\xa7')      -- SECTION SIGN
  , ("':", '\xa8')      -- DIAERESIS
  , ("Co", '\xa9')      -- COPYRIGHT SIGN
  , ("-a", '\xaa')      -- FEMININE ORDINAL INDICATOR
  , ("<<", '\xab')      -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
  , ("NO", '\xac')      -- NOT SIGN
  , ("--", '\xad')      -- SOFT HYPHEN
  , ("Rg", '\xae')      -- REGISTERED SIGN
  , ("'m", '\xaf')      -- MACRON
  , ("DG", '\xb0')      -- DEGREE SIGN
  , ("+-", '\xb1')      -- PLUS-MINUS SIGN
  , ("2S", '\xb2')      -- SUPERSCRIPT TWO
  , ("3S", '\xb3')      -- SUPERSCRIPT THREE
  , ("''", '\xb4')      -- ACUTE ACCENT
  , ("My", '\xb5')      -- MICRO SIGN
  , ("PI", '\xb6')      -- PILCROW SIGN
  , (".M", '\xb7')      -- MIDDLE DOT
  , ("',", '\xb8')      -- CEDILLA
  , ("1S", '\xb9')      -- SUPERSCRIPT ONE
  , ("-o", '\xba')      -- MASCULINE ORDINAL INDICATOR
  , (">>", '\xbb')      -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
  , ("14", '\xbc')      -- VULGAR FRACTION ONE QUARTER
  , ("12", '\xbd')      -- VULGAR FRACTION ONE HALF
  , ("34", '\xbe')      -- VULGAR FRACTION THREE QUARTERS
  , ("?I", '\xbf')      -- INVERTED QUESTION MARK
  , ("A!", '\xc0')      -- LATIN CAPITAL LETTER A WITH GRAVE
  , ("A'", '\xc1')      -- LATIN CAPITAL LETTER A WITH ACUTE
  , ("A>", '\xc2')      -- LATIN CAPITAL LETTER A WITH CIRCUMFLEX
  , ("A?", '\xc3')      -- LATIN CAPITAL LETTER A WITH TILDE
  , ("A:", '\xc4')      -- LATIN CAPITAL LETTER A WITH DIAERESIS
  , ("AA", '\xc5')      -- LATIN CAPITAL LETTER A WITH RING ABOVE
  , ("AE", '\xc6')      -- LATIN CAPITAL LETTER AE
  , ("C,", '\xc7')      -- LATIN CAPITAL LETTER C WITH CEDILLA
  , ("E!", '\xc8')      -- LATIN CAPITAL LETTER E WITH GRAVE
  , ("E'", '\xc9')      -- LATIN CAPITAL LETTER E WITH ACUTE
  , ("E>", '\xca')      -- LATIN CAPITAL LETTER E WITH CIRCUMFLEX
  , ("E:", '\xcb')      -- LATIN CAPITAL LETTER E WITH DIAERESIS
  , ("I!", '\xcc')      -- LATIN CAPITAL LETTER I WITH GRAVE
  , ("I'", '\xcd')      -- LATIN CAPITAL LETTER I WITH ACUTE
  , ("I>", '\xce')      -- LATIN CAPITAL LETTER I WITH CIRCUMFLEX
  , ("I:", '\xcf')      -- LATIN CAPITAL LETTER I WITH DIAERESIS
  , ("D-", '\xd0')      -- LATIN CAPITAL LETTER ETH (Icelandic)
  , ("N?", '\xd1')      -- LATIN CAPITAL LETTER N WITH TILDE
  , ("O!", '\xd2')      -- LATIN CAPITAL LETTER O WITH GRAVE
  , ("O'", '\xd3')      -- LATIN CAPITAL LETTER O WITH ACUTE
  , ("O>", '\xd4')      -- LATIN CAPITAL LETTER O WITH CIRCUMFLEX
  , ("O?", '\xd5')      -- LATIN CAPITAL LETTER O WITH TILDE
  , ("O:", '\xd6')      -- LATIN CAPITAL LETTER O WITH DIAERESIS
  , ("*X", '\xd7')      -- MULTIPLICATION SIGN
  , ("O/", '\xd8')      -- LATIN CAPITAL LETTER O WITH STROKE
  , ("U!", '\xd9')      -- LATIN CAPITAL LETTER U WITH GRAVE
  , ("U'", '\xda')      -- LATIN CAPITAL LETTER U WITH ACUTE
  , ("U>", '\xdb')      -- LATIN CAPITAL LETTER U WITH CIRCUMFLEX
  , ("U:", '\xdc')      -- LATIN CAPITAL LETTER U WITH DIAERESIS
  , ("Y'", '\xdd')      -- LATIN CAPITAL LETTER Y WITH ACUTE
  , ("TH", '\xde')      -- LATIN CAPITAL LETTER THORN (Icelandic)
  , ("ss", '\xdf')      -- LATIN SMALL LETTER SHARP S (German)
  , ("a!", '\xe0')      -- LATIN SMALL LETTER A WITH GRAVE
  , ("a'", '\xe1')      -- LATIN SMALL LETTER A WITH ACUTE
  , ("a>", '\xe2')      -- LATIN SMALL LETTER A WITH CIRCUMFLEX
  , ("a?", '\xe3')      -- LATIN SMALL LETTER A WITH TILDE
  , ("a:", '\xe4')      -- LATIN SMALL LETTER A WITH DIAERESIS
  , ("aa", '\xe5')      -- LATIN SMALL LETTER A WITH RING ABOVE
  , ("ae", '\xe6')      -- LATIN SMALL LETTER AE
  , ("c,", '\xe7')      -- LATIN SMALL LETTER C WITH CEDILLA
  , ("e!", '\xe8')      -- LATIN SMALL LETTER E WITH GRAVE
  , ("e'", '\xe9')      -- LATIN SMALL LETTER E WITH ACUTE
  , ("e>", '\xea')      -- LATIN SMALL LETTER E WITH CIRCUMFLEX
  , ("e:", '\xeb')      -- LATIN SMALL LETTER E WITH DIAERESIS
  , ("i!", '\xec')      -- LATIN SMALL LETTER I WITH GRAVE
  , ("i'", '\xed')      -- LATIN SMALL LETTER I WITH ACUTE
  , ("i>", '\xee')      -- LATIN SMALL LETTER I WITH CIRCUMFLEX
  , ("i:", '\xef')      -- LATIN SMALL LETTER I WITH DIAERESIS
  , ("d-", '\xf0')      -- LATIN SMALL LETTER ETH (Icelandic)
  , ("n?", '\xf1')      -- LATIN SMALL LETTER N WITH TILDE
  , ("o!", '\xf2')      -- LATIN SMALL LETTER O WITH GRAVE
  , ("o'", '\xf3')      -- LATIN SMALL LETTER O WITH ACUTE
  , ("o>", '\xf4')      -- LATIN SMALL LETTER O WITH CIRCUMFLEX
  , ("o?", '\xf5')      -- LATIN SMALL LETTER O WITH TILDE
  , ("o:", '\xf6')      -- LATIN SMALL LETTER O WITH DIAERESIS
  , ("-:", '\xf7')      -- DIVISION SIGN
  , ("o/", '\xf8')      -- LATIN SMALL LETTER O WITH STROKE
  , ("u!", '\xf9')      -- LATIN SMALL LETTER U WITH GRAVE
  , ("u'", '\xfa')      -- LATIN SMALL LETTER U WITH ACUTE
  , ("u>", '\xfb')      -- LATIN SMALL LETTER U WITH CIRCUMFLEX
  , ("u:", '\xfc')      -- LATIN SMALL LETTER U WITH DIAERESIS
  , ("y'", '\xfd')      -- LATIN SMALL LETTER Y WITH ACUTE
  , ("th", '\xfe')      -- LATIN SMALL LETTER THORN (Icelandic)
  , ("y:", '\xff')      -- LATIN SMALL LETTER Y WITH DIAERESIS
  , ("A-", '\x0100')    -- LATIN CAPITAL LETTER A WITH MACRON
  , ("a-", '\x0101')    -- LATIN SMALL LETTER A WITH MACRON
  , ("A(", '\x0102')    -- LATIN CAPITAL LETTER A WITH BREVE
  , ("a(", '\x0103')    -- LATIN SMALL LETTER A WITH BREVE
  , ("A;", '\x0104')    -- LATIN CAPITAL LETTER A WITH OGONEK
  , ("a;", '\x0105')    -- LATIN SMALL LETTER A WITH OGONEK
  , ("C'", '\x0106')    -- LATIN CAPITAL LETTER C WITH ACUTE
  , ("c'", '\x0107')    -- LATIN SMALL LETTER C WITH ACUTE
  , ("C>", '\x0108')    -- LATIN CAPITAL LETTER C WITH CIRCUMFLEX
  , ("c>", '\x0109')    -- LATIN SMALL LETTER C WITH CIRCUMFLEX
  , ("C.", '\x010A')    -- LATIN CAPITAL LETTER C WITH DOT ABOVE
  , ("c.", '\x010B')    -- LATIN SMALL LETTER C WITH DOT ABOVE
  , ("C<", '\x010C')    -- LATIN CAPITAL LETTER C WITH CARON
  , ("c<", '\x010D')    -- LATIN SMALL LETTER C WITH CARON
  , ("D<", '\x010E')    -- LATIN CAPITAL LETTER D WITH CARON
  , ("d<", '\x010F')    -- LATIN SMALL LETTER D WITH CARON
  , ("D/", '\x0110')    -- LATIN CAPITAL LETTER D WITH STROKE
  , ("d/", '\x0111')    -- LATIN SMALL LETTER D WITH STROKE
  , ("E-", '\x0112')    -- LATIN CAPITAL LETTER E WITH MACRON
  , ("e-", '\x0113')    -- LATIN SMALL LETTER E WITH MACRON
  , ("E(", '\x0114')    -- LATIN CAPITAL LETTER E WITH BREVE
  , ("e(", '\x0115')    -- LATIN SMALL LETTER E WITH BREVE
  , ("E.", '\x0116')    -- LATIN CAPITAL LETTER E WITH DOT ABOVE
  , ("e.", '\x0117')    -- LATIN SMALL LETTER E WITH DOT ABOVE
  , ("E;", '\x0118')    -- LATIN CAPITAL LETTER E WITH OGONEK
  , ("e;", '\x0119')    -- LATIN SMALL LETTER E WITH OGONEK
  , ("E<", '\x011A')    -- LATIN CAPITAL LETTER E WITH CARON
  , ("e<", '\x011B')    -- LATIN SMALL LETTER E WITH CARON
  , ("G>", '\x011C')    -- LATIN CAPITAL LETTER G WITH CIRCUMFLEX
  , ("g>", '\x011D')    -- LATIN SMALL LETTER G WITH CIRCUMFLEX
  , ("G(", '\x011E')    -- LATIN CAPITAL LETTER G WITH BREVE
  , ("g(", '\x011F')    -- LATIN SMALL LETTER G WITH BREVE
  , ("G.", '\x0120')    -- LATIN CAPITAL LETTER G WITH DOT ABOVE
  , ("g.", '\x0121')    -- LATIN SMALL LETTER G WITH DOT ABOVE
  , ("G,", '\x0122')    -- LATIN CAPITAL LETTER G WITH CEDILLA
  , ("g,", '\x0123')    -- LATIN SMALL LETTER G WITH CEDILLA
  , ("H>", '\x0124')    -- LATIN CAPITAL LETTER H WITH CIRCUMFLEX
  , ("h>", '\x0125')    -- LATIN SMALL LETTER H WITH CIRCUMFLEX
  , ("H/", '\x0126')    -- LATIN CAPITAL LETTER H WITH STROKE
  , ("h/", '\x0127')    -- LATIN SMALL LETTER H WITH STROKE
  , ("I?", '\x0128')    -- LATIN CAPITAL LETTER I WITH TILDE
  , ("i?", '\x0129')    -- LATIN SMALL LETTER I WITH TILDE
  , ("I-", '\x012A')    -- LATIN CAPITAL LETTER I WITH MACRON
  , ("i-", '\x012B')    -- LATIN SMALL LETTER I WITH MACRON
  , ("I(", '\x012C')    -- LATIN CAPITAL LETTER I WITH BREVE
  , ("i(", '\x012D')    -- LATIN SMALL LETTER I WITH BREVE
  , ("I;", '\x012E')    -- LATIN CAPITAL LETTER I WITH OGONEK
  , ("i;", '\x012F')    -- LATIN SMALL LETTER I WITH OGONEK
  , ("I.", '\x0130')    -- LATIN CAPITAL LETTER I WITH DOT ABOVE
  , ("i.", '\x0131')    -- LATIN SMALL LETTER DOTLESS I
  , ("IJ", '\x0132')    -- LATIN CAPITAL LIGATURE IJ
  , ("ij", '\x0133')    -- LATIN SMALL LIGATURE IJ
  , ("J>", '\x0134')    -- LATIN CAPITAL LETTER J WITH CIRCUMFLEX
  , ("j>", '\x0135')    -- LATIN SMALL LETTER J WITH CIRCUMFLEX
  , ("K,", '\x0136')    -- LATIN CAPITAL LETTER K WITH CEDILLA
  , ("k,", '\x0137')    -- LATIN SMALL LETTER K WITH CEDILLA
  , ("kk", '\x0138')    -- LATIN SMALL LETTER KRA
  , ("L'", '\x0139')    -- LATIN CAPITAL LETTER L WITH ACUTE
  , ("l'", '\x013A')    -- LATIN SMALL LETTER L WITH ACUTE
  , ("L,", '\x013B')    -- LATIN CAPITAL LETTER L WITH CEDILLA
  , ("l,", '\x013C')    -- LATIN SMALL LETTER L WITH CEDILLA
  , ("L<", '\x013D')    -- LATIN CAPITAL LETTER L WITH CARON
  , ("l<", '\x013E')    -- LATIN SMALL LETTER L WITH CARON
  , ("L.", '\x013F')    -- LATIN CAPITAL LETTER L WITH MIDDLE DOT
  , ("l.", '\x0140')    -- LATIN SMALL LETTER L WITH MIDDLE DOT
  , ("L/", '\x0141')    -- LATIN CAPITAL LETTER L WITH STROKE
  , ("l/", '\x0142')    -- LATIN SMALL LETTER L WITH STROKE
  , ("N'", '\x0143')    -- LATIN CAPITAL LETTER N WITH ACUTE `
  , ("n'", '\x0144')    -- LATIN SMALL LETTER N WITH ACUTE `
  , ("N,", '\x0145')    -- LATIN CAPITAL LETTER N WITH CEDILLA `
  , ("n,", '\x0146')    -- LATIN SMALL LETTER N WITH CEDILLA `
  , ("N<", '\x0147')    -- LATIN CAPITAL LETTER N WITH CARON `
  , ("n<", '\x0148')    -- LATIN SMALL LETTER N WITH CARON `
  , ("'n", '\x0149')    -- LATIN SMALL LETTER N PRECEDED BY APOSTROPHE `
  , ("NG", '\x014A')    -- LATIN CAPITAL LETTER ENG
  , ("ng", '\x014B')    -- LATIN SMALL LETTER ENG
  , ("O-", '\x014C')    -- LATIN CAPITAL LETTER O WITH MACRON
  , ("o-", '\x014D')    -- LATIN SMALL LETTER O WITH MACRON
  , ("O(", '\x014E')    -- LATIN CAPITAL LETTER O WITH BREVE
  , ("o(", '\x014F')    -- LATIN SMALL LETTER O WITH BREVE
  , ("O\"", '\x0150')   -- LATIN CAPITAL LETTER O WITH DOUBLE ACUTE
  , ("o\"", '\x0151')   -- LATIN SMALL LETTER O WITH DOUBLE ACUTE
  , ("OE", '\x0152')    -- LATIN CAPITAL LIGATURE OE
  , ("oe", '\x0153')    -- LATIN SMALL LIGATURE OE
  , ("R'", '\x0154')    -- LATIN CAPITAL LETTER R WITH ACUTE
  , ("r'", '\x0155')    -- LATIN SMALL LETTER R WITH ACUTE
  , ("R,", '\x0156')    -- LATIN CAPITAL LETTER R WITH CEDILLA
  , ("r,", '\x0157')    -- LATIN SMALL LETTER R WITH CEDILLA
  , ("R<", '\x0158')    -- LATIN CAPITAL LETTER R WITH CARON
  , ("r<", '\x0159')    -- LATIN SMALL LETTER R WITH CARON
  , ("S'", '\x015A')    -- LATIN CAPITAL LETTER S WITH ACUTE
  , ("s'", '\x015B')    -- LATIN SMALL LETTER S WITH ACUTE
  , ("S>", '\x015C')    -- LATIN CAPITAL LETTER S WITH CIRCUMFLEX
  , ("s>", '\x015D')    -- LATIN SMALL LETTER S WITH CIRCUMFLEX
  , ("S,", '\x015E')    -- LATIN CAPITAL LETTER S WITH CEDILLA
  , ("s,", '\x015F')    -- LATIN SMALL LETTER S WITH CEDILLA
  , ("S<", '\x0160')    -- LATIN CAPITAL LETTER S WITH CARON
  , ("s<", '\x0161')    -- LATIN SMALL LETTER S WITH CARON
  , ("T,", '\x0162')    -- LATIN CAPITAL LETTER T WITH CEDILLA
  , ("t,", '\x0163')    -- LATIN SMALL LETTER T WITH CEDILLA
  , ("T<", '\x0164')    -- LATIN CAPITAL LETTER T WITH CARON
  , ("t<", '\x0165')    -- LATIN SMALL LETTER T WITH CARON
  , ("T/", '\x0166')    -- LATIN CAPITAL LETTER T WITH STROKE
  , ("t/", '\x0167')    -- LATIN SMALL LETTER T WITH STROKE
  , ("U?", '\x0168')    -- LATIN CAPITAL LETTER U WITH TILDE
  , ("u?", '\x0169')    -- LATIN SMALL LETTER U WITH TILDE
  , ("U-", '\x016A')    -- LATIN CAPITAL LETTER U WITH MACRON
  , ("u-", '\x016B')    -- LATIN SMALL LETTER U WITH MACRON
  , ("U(", '\x016C')    -- LATIN CAPITAL LETTER U WITH BREVE
  , ("u(", '\x016D')    -- LATIN SMALL LETTER U WITH BREVE
  , ("U0", '\x016E')    -- LATIN CAPITAL LETTER U WITH RING ABOVE
  , ("u0", '\x016F')    -- LATIN SMALL LETTER U WITH RING ABOVE
  , ("U\"", '\x0170')   -- LATIN CAPITAL LETTER U WITH DOUBLE ACUTE
  , ("u\"", '\x0171')   -- LATIN SMALL LETTER U WITH DOUBLE ACUTE
  , ("U;", '\x0172')    -- LATIN CAPITAL LETTER U WITH OGONEK
  , ("u;", '\x0173')    -- LATIN SMALL LETTER U WITH OGONEK
  , ("W>", '\x0174')    -- LATIN CAPITAL LETTER W WITH CIRCUMFLEX
  , ("w>", '\x0175')    -- LATIN SMALL LETTER W WITH CIRCUMFLEX
  , ("Y>", '\x0176')    -- LATIN CAPITAL LETTER Y WITH CIRCUMFLEX
  , ("y>", '\x0177')    -- LATIN SMALL LETTER Y WITH CIRCUMFLEX
  , ("Y:", '\x0178')    -- LATIN CAPITAL LETTER Y WITH DIAERESIS
  , ("Z'", '\x0179')    -- LATIN CAPITAL LETTER Z WITH ACUTE
  , ("z'", '\x017A')    -- LATIN SMALL LETTER Z WITH ACUTE
  , ("Z.", '\x017B')    -- LATIN CAPITAL LETTER Z WITH DOT ABOVE
  , ("z.", '\x017C')    -- LATIN SMALL LETTER Z WITH DOT ABOVE
  , ("Z<", '\x017D')    -- LATIN CAPITAL LETTER Z WITH CARON
  , ("z<", '\x017E')    -- LATIN SMALL LETTER Z WITH CARON
  , ("O9", '\x01A0')    -- LATIN CAPITAL LETTER O WITH HORN
  , ("o9", '\x01A1')    -- LATIN SMALL LETTER O WITH HORN
  , ("OI", '\x01A2')    -- LATIN CAPITAL LETTER OI
  , ("oi", '\x01A3')    -- LATIN SMALL LETTER OI
  , ("yr", '\x01A6')    -- LATIN LETTER YR
  , ("U9", '\x01AF')    -- LATIN CAPITAL LETTER U WITH HORN
  , ("u9", '\x01B0')    -- LATIN SMALL LETTER U WITH HORN
  , ("Z/", '\x01B5')    -- LATIN CAPITAL LETTER Z WITH STROKE
  , ("z/", '\x01B6')    -- LATIN SMALL LETTER Z WITH STROKE
  , ("ED", '\x01B7')    -- LATIN CAPITAL LETTER EZH
  , ("A<", '\x01CD')    -- LATIN CAPITAL LETTER A WITH CARON
  , ("a<", '\x01CE')    -- LATIN SMALL LETTER A WITH CARON
  , ("I<", '\x01CF')    -- LATIN CAPITAL LETTER I WITH CARON
  , ("i<", '\x01D0')    -- LATIN SMALL LETTER I WITH CARON
  , ("O<", '\x01D1')    -- LATIN CAPITAL LETTER O WITH CARON
  , ("o<", '\x01D2')    -- LATIN SMALL LETTER O WITH CARON
  , ("U<", '\x01D3')    -- LATIN CAPITAL LETTER U WITH CARON
  , ("u<", '\x01D4')    -- LATIN SMALL LETTER U WITH CARON
  , ("A1", '\x01DE')    -- LATIN CAPITAL LETTER A WITH DIAERESIS AND MACRON
  , ("a1", '\x01DF')    -- LATIN SMALL LETTER A WITH DIAERESIS AND MACRON
  , ("A7", '\x01E0')    -- LATIN CAPITAL LETTER A WITH DOT ABOVE AND MACRON
  , ("a7", '\x01E1')    -- LATIN SMALL LETTER A WITH DOT ABOVE AND MACRON
  , ("A3", '\x01E2')    -- LATIN CAPITAL LETTER AE WITH MACRON
  , ("a3", '\x01E3')    -- LATIN SMALL LETTER AE WITH MACRON
  , ("G/", '\x01E4')    -- LATIN CAPITAL LETTER G WITH STROKE
  , ("g/", '\x01E5')    -- LATIN SMALL LETTER G WITH STROKE
  , ("G<", '\x01E6')    -- LATIN CAPITAL LETTER G WITH CARON
  , ("g<", '\x01E7')    -- LATIN SMALL LETTER G WITH CARON
  , ("K<", '\x01E8')    -- LATIN CAPITAL LETTER K WITH CARON
  , ("k<", '\x01E9')    -- LATIN SMALL LETTER K WITH CARON
  , ("O;", '\x01EA')    -- LATIN CAPITAL LETTER O WITH OGONEK
  , ("o;", '\x01EB')    -- LATIN SMALL LETTER O WITH OGONEK
  , ("O1", '\x01EC')    -- LATIN CAPITAL LETTER O WITH OGONEK AND MACRON
  , ("o1", '\x01ED')    -- LATIN SMALL LETTER O WITH OGONEK AND MACRON
  , ("EZ", '\x01EE')    -- LATIN CAPITAL LETTER EZH WITH CARON
  , ("ez", '\x01EF')    -- LATIN SMALL LETTER EZH WITH CARON
  , ("j<", '\x01F0')    -- LATIN SMALL LETTER J WITH CARON
  , ("G'", '\x01F4')    -- LATIN CAPITAL LETTER G WITH ACUTE
  , ("g'", '\x01F5')    -- LATIN SMALL LETTER G WITH ACUTE
  , (";S", '\x02BF')    -- MODIFIER LETTER LEFT HALF RING
  , ("'<", '\x02C7')    -- CARON
  , ("'(", '\x02D8')    -- BREVE
  , ("'.", '\x02D9')    -- DOT ABOVE
  , ("'0", '\x02DA')    -- RING ABOVE
  , ("';", '\x02DB')    -- OGONEK
  , ("'\"",'\x02DD')    -- DOUBLE ACUTE ACCENT
  , ("A%", '\x0386')    -- GREEK CAPITAL LETTER ALPHA WITH TONOS
  , ("E%", '\x0388')    -- GREEK CAPITAL LETTER EPSILON WITH TONOS
  , ("Y%", '\x0389')    -- GREEK CAPITAL LETTER ETA WITH TONOS
  , ("I%", '\x038A')    -- GREEK CAPITAL LETTER IOTA WITH TONOS
  , ("O%", '\x038C')    -- GREEK CAPITAL LETTER OMICRON WITH TONOS
  , ("U%", '\x038E')    -- GREEK CAPITAL LETTER UPSILON WITH TONOS
  , ("W%", '\x038F')    -- GREEK CAPITAL LETTER OMEGA WITH TONOS
  , ("i3", '\x0390')    -- GREEK SMALL LETTER IOTA WITH DIALYTIKA AND TONOS
  , ("A*", '\x0391')    -- GREEK CAPITAL LETTER ALPHA
  , ("B*", '\x0392')    -- GREEK CAPITAL LETTER BETA
  , ("G*", '\x0393')    -- GREEK CAPITAL LETTER GAMMA
  , ("D*", '\x0394')    -- GREEK CAPITAL LETTER DELTA
  , ("E*", '\x0395')    -- GREEK CAPITAL LETTER EPSILON
  , ("Z*", '\x0396')    -- GREEK CAPITAL LETTER ZETA
  , ("Y*", '\x0397')    -- GREEK CAPITAL LETTER ETA
  , ("H*", '\x0398')    -- GREEK CAPITAL LETTER THETA
  , ("I*", '\x0399')    -- GREEK CAPITAL LETTER IOTA
  , ("K*", '\x039A')    -- GREEK CAPITAL LETTER KAPPA
  , ("L*", '\x039B')    -- GREEK CAPITAL LETTER LAMDA
  , ("M*", '\x039C')    -- GREEK CAPITAL LETTER MU
  , ("N*", '\x039D')    -- GREEK CAPITAL LETTER NU
  , ("C*", '\x039E')    -- GREEK CAPITAL LETTER XI
  , ("O*", '\x039F')    -- GREEK CAPITAL LETTER OMICRON
  , ("P*", '\x03A0')    -- GREEK CAPITAL LETTER PI
  , ("R*", '\x03A1')    -- GREEK CAPITAL LETTER RHO
  , ("S*", '\x03A3')    -- GREEK CAPITAL LETTER SIGMA
  , ("T*", '\x03A4')    -- GREEK CAPITAL LETTER TAU
  , ("U*", '\x03A5')    -- GREEK CAPITAL LETTER UPSILON
  , ("F*", '\x03A6')    -- GREEK CAPITAL LETTER PHI
  , ("X*", '\x03A7')    -- GREEK CAPITAL LETTER CHI
  , ("Q*", '\x03A8')    -- GREEK CAPITAL LETTER PSI
  , ("W*", '\x03A9')    -- GREEK CAPITAL LETTER OMEGA
  , ("J*", '\x03AA')    -- GREEK CAPITAL LETTER IOTA WITH DIALYTIKA
  , ("V*", '\x03AB')    -- GREEK CAPITAL LETTER UPSILON WITH DIALYTIKA
  , ("a%", '\x03AC')    -- GREEK SMALL LETTER ALPHA WITH TONOS
  , ("e%", '\x03AD')    -- GREEK SMALL LETTER EPSILON WITH TONOS
  , ("y%", '\x03AE')    -- GREEK SMALL LETTER ETA WITH TONOS
  , ("i%", '\x03AF')    -- GREEK SMALL LETTER IOTA WITH TONOS
  , ("u3", '\x03B0')    -- GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND TONOS
  , ("a*", '\x03B1')    -- GREEK SMALL LETTER ALPHA
  , ("b*", '\x03B2')    -- GREEK SMALL LETTER BETA
  , ("g*", '\x03B3')    -- GREEK SMALL LETTER GAMMA
  , ("d*", '\x03B4')    -- GREEK SMALL LETTER DELTA
  , ("e*", '\x03B5')    -- GREEK SMALL LETTER EPSILON
  , ("z*", '\x03B6')    -- GREEK SMALL LETTER ZETA
  , ("y*", '\x03B7')    -- GREEK SMALL LETTER ETA
  , ("h*", '\x03B8')    -- GREEK SMALL LETTER THETA
  , ("i*", '\x03B9')    -- GREEK SMALL LETTER IOTA
  , ("k*", '\x03BA')    -- GREEK SMALL LETTER KAPPA
  , ("l*", '\x03BB')    -- GREEK SMALL LETTER LAMDA
  , ("m*", '\x03BC')    -- GREEK SMALL LETTER MU
  , ("n*", '\x03BD')    -- GREEK SMALL LETTER NU
  , ("c*", '\x03BE')    -- GREEK SMALL LETTER XI
  , ("o*", '\x03BF')    -- GREEK SMALL LETTER OMICRON
  , ("p*", '\x03C0')    -- GREEK SMALL LETTER PI
  , ("r*", '\x03C1')    -- GREEK SMALL LETTER RHO
  , ("*s", '\x03C2')    -- GREEK SMALL LETTER FINAL SIGMA
  , ("s*", '\x03C3')    -- GREEK SMALL LETTER SIGMA
  , ("t*", '\x03C4')    -- GREEK SMALL LETTER TAU
  , ("u*", '\x03C5')    -- GREEK SMALL LETTER UPSILON
  , ("f*", '\x03C6')    -- GREEK SMALL LETTER PHI
  , ("x*", '\x03C7')    -- GREEK SMALL LETTER CHI
  , ("q*", '\x03C8')    -- GREEK SMALL LETTER PSI
  , ("w*", '\x03C9')    -- GREEK SMALL LETTER OMEGA
  , ("j*", '\x03CA')    -- GREEK SMALL LETTER IOTA WITH DIALYTIKA
  , ("v*", '\x03CB')    -- GREEK SMALL LETTER UPSILON WITH DIALYTIKA
  , ("o%", '\x03CC')    -- GREEK SMALL LETTER OMICRON WITH TONOS
  , ("u%", '\x03CD')    -- GREEK SMALL LETTER UPSILON WITH TONOS
  , ("w%", '\x03CE')    -- GREEK SMALL LETTER OMEGA WITH TONOS
  , ("'G", '\x03D8')    -- GREEK LETTER ARCHAIC KOPPA
  , (",G", '\x03D9')    -- GREEK SMALL LETTER ARCHAIC KOPPA
  , ("T3", '\x03DA')    -- GREEK LETTER STIGMA
  , ("t3", '\x03DB')    -- GREEK SMALL LETTER STIGMA
  , ("M3", '\x03DC')    -- GREEK LETTER DIGAMMA
  , ("m3", '\x03DD')    -- GREEK SMALL LETTER DIGAMMA
  , ("K3", '\x03DE')    -- GREEK LETTER KOPPA
  , ("k3", '\x03DF')    -- GREEK SMALL LETTER KOPPA
  , ("P3", '\x03E0')    -- GREEK LETTER SAMPI
  , ("p3", '\x03E1')    -- GREEK SMALL LETTER SAMPI
  , ("'%", '\x03F4')    -- GREEK CAPITAL THETA SYMBOL
  , ("j3", '\x03F5')    -- GREEK LUNATE EPSILON SYMBOL
  , ("IO", '\x0401')    -- CYRILLIC CAPITAL LETTER IO
  , ("D%", '\x0402')    -- CYRILLIC CAPITAL LETTER DJE
  , ("G%", '\x0403')    -- CYRILLIC CAPITAL LETTER GJE
  , ("IE", '\x0404')    -- CYRILLIC CAPITAL LETTER UKRAINIAN IE
  , ("DS", '\x0405')    -- CYRILLIC CAPITAL LETTER DZE
  , ("II", '\x0406')    -- CYRILLIC CAPITAL LETTER BYELORUSSIAN-UKRAINIAN I
  , ("YI", '\x0407')    -- CYRILLIC CAPITAL LETTER YI
  , ("J%", '\x0408')    -- CYRILLIC CAPITAL LETTER JE
  , ("LJ", '\x0409')    -- CYRILLIC CAPITAL LETTER LJE
  , ("NJ", '\x040A')    -- CYRILLIC CAPITAL LETTER NJE
  , ("Ts", '\x040B')    -- CYRILLIC CAPITAL LETTER TSHE
  , ("KJ", '\x040C')    -- CYRILLIC CAPITAL LETTER KJE
  , ("V%", '\x040E')    -- CYRILLIC CAPITAL LETTER SHORT U
  , ("DZ", '\x040F')    -- CYRILLIC CAPITAL LETTER DZHE
  , ("A=", '\x0410')    -- CYRILLIC CAPITAL LETTER A
  , ("B=", '\x0411')    -- CYRILLIC CAPITAL LETTER BE
  , ("V=", '\x0412')    -- CYRILLIC CAPITAL LETTER VE
  , ("G=", '\x0413')    -- CYRILLIC CAPITAL LETTER GHE
  , ("D=", '\x0414')    -- CYRILLIC CAPITAL LETTER DE
  , ("E=", '\x0415')    -- CYRILLIC CAPITAL LETTER IE
  , ("Z%", '\x0416')    -- CYRILLIC CAPITAL LETTER ZHE
  , ("Z=", '\x0417')    -- CYRILLIC CAPITAL LETTER ZE
  , ("I=", '\x0418')    -- CYRILLIC CAPITAL LETTER I
  , ("J=", '\x0419')    -- CYRILLIC CAPITAL LETTER SHORT I
  , ("K=", '\x041A')    -- CYRILLIC CAPITAL LETTER KA
  , ("L=", '\x041B')    -- CYRILLIC CAPITAL LETTER EL
  , ("M=", '\x041C')    -- CYRILLIC CAPITAL LETTER EM
  , ("N=", '\x041D')    -- CYRILLIC CAPITAL LETTER EN
  , ("O=", '\x041E')    -- CYRILLIC CAPITAL LETTER O
  , ("P=", '\x041F')    -- CYRILLIC CAPITAL LETTER PE
  , ("R=", '\x0420')    -- CYRILLIC CAPITAL LETTER ER
  , ("S=", '\x0421')    -- CYRILLIC CAPITAL LETTER ES
  , ("T=", '\x0422')    -- CYRILLIC CAPITAL LETTER TE
  , ("U=", '\x0423')    -- CYRILLIC CAPITAL LETTER U
  , ("F=", '\x0424')    -- CYRILLIC CAPITAL LETTER EF
  , ("H=", '\x0425')    -- CYRILLIC CAPITAL LETTER HA
  , ("C=", '\x0426')    -- CYRILLIC CAPITAL LETTER TSE
  , ("C%", '\x0427')    -- CYRILLIC CAPITAL LETTER CHE
  , ("S%", '\x0428')    -- CYRILLIC CAPITAL LETTER SHA
  , ("Sc", '\x0429')    -- CYRILLIC CAPITAL LETTER SHCHA
  , ("=\"", '\x042A')   -- CYRILLIC CAPITAL LETTER HARD SIGN
  , ("Y=", '\x042B')    -- CYRILLIC CAPITAL LETTER YERU
  , ("%\"", '\x042C')   -- CYRILLIC CAPITAL LETTER SOFT SIGN
  , ("JE", '\x042D')    -- CYRILLIC CAPITAL LETTER E
  , ("JU", '\x042E')    -- CYRILLIC CAPITAL LETTER YU
  , ("JA", '\x042F')    -- CYRILLIC CAPITAL LETTER YA
  , ("a=", '\x0430')    -- CYRILLIC SMALL LETTER A
  , ("b=", '\x0431')    -- CYRILLIC SMALL LETTER BE
  , ("v=", '\x0432')    -- CYRILLIC SMALL LETTER VE
  , ("g=", '\x0433')    -- CYRILLIC SMALL LETTER GHE
  , ("d=", '\x0434')    -- CYRILLIC SMALL LETTER DE
  , ("e=", '\x0435')    -- CYRILLIC SMALL LETTER IE
  , ("z%", '\x0436')    -- CYRILLIC SMALL LETTER ZHE
  , ("z=", '\x0437')    -- CYRILLIC SMALL LETTER ZE
  , ("i=", '\x0438')    -- CYRILLIC SMALL LETTER I
  , ("j=", '\x0439')    -- CYRILLIC SMALL LETTER SHORT I
  , ("k=", '\x043A')    -- CYRILLIC SMALL LETTER KA
  , ("l=", '\x043B')    -- CYRILLIC SMALL LETTER EL
  , ("m=", '\x043C')    -- CYRILLIC SMALL LETTER EM
  , ("n=", '\x043D')    -- CYRILLIC SMALL LETTER EN
  , ("o=", '\x043E')    -- CYRILLIC SMALL LETTER O
  , ("p=", '\x043F')    -- CYRILLIC SMALL LETTER PE
  , ("r=", '\x0440')    -- CYRILLIC SMALL LETTER ER
  , ("s=", '\x0441')    -- CYRILLIC SMALL LETTER ES
  , ("t=", '\x0442')    -- CYRILLIC SMALL LETTER TE
  , ("u=", '\x0443')    -- CYRILLIC SMALL LETTER U
  , ("f=", '\x0444')    -- CYRILLIC SMALL LETTER EF
  , ("h=", '\x0445')    -- CYRILLIC SMALL LETTER HA
  , ("c=", '\x0446')    -- CYRILLIC SMALL LETTER TSE
  , ("c%", '\x0447')    -- CYRILLIC SMALL LETTER CHE
  , ("s%", '\x0448')    -- CYRILLIC SMALL LETTER SHA
  , ("sc", '\x0449')    -- CYRILLIC SMALL LETTER SHCHA
  , ("='", '\x044A')    -- CYRILLIC SMALL LETTER HARD SIGN
  , ("y=", '\x044B')    -- CYRILLIC SMALL LETTER YERU
  , ("%'", '\x044C')    -- CYRILLIC SMALL LETTER SOFT SIGN
  , ("je", '\x044D')    -- CYRILLIC SMALL LETTER E
  , ("ju", '\x044E')    -- CYRILLIC SMALL LETTER YU
  , ("ja", '\x044F')    -- CYRILLIC SMALL LETTER YA
  , ("io", '\x0451')    -- CYRILLIC SMALL LETTER IO
  , ("d%", '\x0452')    -- CYRILLIC SMALL LETTER DJE
  , ("g%", '\x0453')    -- CYRILLIC SMALL LETTER GJE
  , ("ie", '\x0454')    -- CYRILLIC SMALL LETTER UKRAINIAN IE
  , ("ds", '\x0455')    -- CYRILLIC SMALL LETTER DZE
  , ("ii", '\x0456')    -- CYRILLIC SMALL LETTER BYELORUSSIAN-UKRAINIAN I
  , ("yi", '\x0457')    -- CYRILLIC SMALL LETTER YI
  , ("j%", '\x0458')    -- CYRILLIC SMALL LETTER JE
  , ("lj", '\x0459')    -- CYRILLIC SMALL LETTER LJE
  , ("nj", '\x045A')    -- CYRILLIC SMALL LETTER NJE
  , ("ts", '\x045B')    -- CYRILLIC SMALL LETTER TSHE
  , ("kj", '\x045C')    -- CYRILLIC SMALL LETTER KJE
  , ("v%", '\x045E')    -- CYRILLIC SMALL LETTER SHORT U
  , ("dz", '\x045F')    -- CYRILLIC SMALL LETTER DZHE
  , ("Y3", '\x0462')    -- CYRILLIC CAPITAL LETTER YAT
  , ("y3", '\x0463')    -- CYRILLIC SMALL LETTER YAT
  , ("O3", '\x046A')    -- CYRILLIC CAPITAL LETTER BIG YUS
  , ("o3", '\x046B')    -- CYRILLIC SMALL LETTER BIG YUS
  , ("F3", '\x0472')    -- CYRILLIC CAPITAL LETTER FITA
  , ("f3", '\x0473')    -- CYRILLIC SMALL LETTER FITA
  , ("V3", '\x0474')    -- CYRILLIC CAPITAL LETTER IZHITSA
  , ("v3", '\x0475')    -- CYRILLIC SMALL LETTER IZHITSA
  , ("C3", '\x0480')    -- CYRILLIC CAPITAL LETTER KOPPA
  , ("c3", '\x0481')    -- CYRILLIC SMALL LETTER KOPPA
  , ("G3", '\x0490')    -- CYRILLIC CAPITAL LETTER GHE WITH UPTURN
  , ("g3", '\x0491')    -- CYRILLIC SMALL LETTER GHE WITH UPTURN
  , ("A+", '\x05D0')    -- HEBREW LETTER ALEF
  , ("B+", '\x05D1')    -- HEBREW LETTER BET
  , ("G+", '\x05D2')    -- HEBREW LETTER GIMEL
  , ("D+", '\x05D3')    -- HEBREW LETTER DALET
  , ("H+", '\x05D4')    -- HEBREW LETTER HE
  , ("W+", '\x05D5')    -- HEBREW LETTER VAV
  , ("Z+", '\x05D6')    -- HEBREW LETTER ZAYIN
  , ("X+", '\x05D7')    -- HEBREW LETTER HET
  , ("Tj", '\x05D8')    -- HEBREW LETTER TET
  , ("J+", '\x05D9')    -- HEBREW LETTER YOD
  , ("K%", '\x05DA')    -- HEBREW LETTER FINAL KAF
  , ("K+", '\x05DB')    -- HEBREW LETTER KAF
  , ("L+", '\x05DC')    -- HEBREW LETTER LAMED
  , ("M%", '\x05DD')    -- HEBREW LETTER FINAL MEM
  , ("M+", '\x05DE')    -- HEBREW LETTER MEM
  , ("N%", '\x05DF')    -- HEBREW LETTER FINAL NUN `
  , ("N+", '\x05E0')    -- HEBREW LETTER NUN `
  , ("S+", '\x05E1')    -- HEBREW LETTER SAMEKH
  , ("E+", '\x05E2')    -- HEBREW LETTER AYIN
  , ("P%", '\x05E3')    -- HEBREW LETTER FINAL PE
  , ("P+", '\x05E4')    -- HEBREW LETTER PE
  , ("Zj", '\x05E5')    -- HEBREW LETTER FINAL TSADI
  , ("ZJ", '\x05E6')    -- HEBREW LETTER TSADI
  , ("Q+", '\x05E7')    -- HEBREW LETTER QOF
  , ("R+", '\x05E8')    -- HEBREW LETTER RESH
  , ("Sh", '\x05E9')    -- HEBREW LETTER SHIN
  , ("T+", '\x05EA')    -- HEBREW LETTER TAV
  , (",+", '\x060C')    -- ARABIC COMMA
  , (";+", '\x061B')    -- ARABIC SEMICOLON
  , ("?+", '\x061F')    -- ARABIC QUESTION MARK
  , ("H'", '\x0621')    -- ARABIC LETTER HAMZA
  , ("aM", '\x0622')    -- ARABIC LETTER ALEF WITH MADDA ABOVE
  , ("aH", '\x0623')    -- ARABIC LETTER ALEF WITH HAMZA ABOVE
  , ("wH", '\x0624')    -- ARABIC LETTER WAW WITH HAMZA ABOVE
  , ("ah", '\x0625')    -- ARABIC LETTER ALEF WITH HAMZA BELOW
  , ("yH", '\x0626')    -- ARABIC LETTER YEH WITH HAMZA ABOVE
  , ("a+", '\x0627')    -- ARABIC LETTER ALEF
  , ("b+", '\x0628')    -- ARABIC LETTER BEH
  , ("tm", '\x0629')    -- ARABIC LETTER TEH MARBUTA
  , ("t+", '\x062A')    -- ARABIC LETTER TEH
  , ("tk", '\x062B')    -- ARABIC LETTER THEH
  , ("g+", '\x062C')    -- ARABIC LETTER JEEM
  , ("hk", '\x062D')    -- ARABIC LETTER HAH
  , ("x+", '\x062E')    -- ARABIC LETTER KHAH
  , ("d+", '\x062F')    -- ARABIC LETTER DAL
  , ("dk", '\x0630')    -- ARABIC LETTER THAL
  , ("r+", '\x0631')    -- ARABIC LETTER REH
  , ("z+", '\x0632')    -- ARABIC LETTER ZAIN
  , ("s+", '\x0633')    -- ARABIC LETTER SEEN
  , ("sn", '\x0634')    -- ARABIC LETTER SHEEN
  , ("c+", '\x0635')    -- ARABIC LETTER SAD
  , ("dd", '\x0636')    -- ARABIC LETTER DAD
  , ("tj", '\x0637')    -- ARABIC LETTER TAH
  , ("zH", '\x0638')    -- ARABIC LETTER ZAH
  , ("e+", '\x0639')    -- ARABIC LETTER AIN
  , ("i+", '\x063A')    -- ARABIC LETTER GHAIN
  , ("++", '\x0640')    -- ARABIC TATWEEL
  , ("f+", '\x0641')    -- ARABIC LETTER FEH
  , ("q+", '\x0642')    -- ARABIC LETTER QAF
  , ("k+", '\x0643')    -- ARABIC LETTER KAF
  , ("l+", '\x0644')    -- ARABIC LETTER LAM
  , ("m+", '\x0645')    -- ARABIC LETTER MEEM
  , ("n+", '\x0646')    -- ARABIC LETTER NOON
  , ("h+", '\x0647')    -- ARABIC LETTER HEH
  , ("w+", '\x0648')    -- ARABIC LETTER WAW
  , ("j+", '\x0649')    -- ARABIC LETTER ALEF MAKSURA
  , ("y+", '\x064A')    -- ARABIC LETTER YEH
  , (":+", '\x064B')    -- ARABIC FATHATAN
  , ("\"+", '\x064C')   -- ARABIC DAMMATAN
  , ("=+", '\x064D')    -- ARABIC KASRATAN
  , ("/+", '\x064E')    -- ARABIC FATHA
  , ("'+", '\x064F')    -- ARABIC DAMMA
  , ("1+", '\x0650')    -- ARABIC KASRA
  , ("3+", '\x0651')    -- ARABIC SHADDA
  , ("0+", '\x0652')    -- ARABIC SUKUN
  , ("aS", '\x0670')    -- ARABIC LETTER SUPERSCRIPT ALEF
  , ("p+", '\x067E')    -- ARABIC LETTER PEH
  , ("v+", '\x06A4')    -- ARABIC LETTER VEH
  , ("gf", '\x06AF')    -- ARABIC LETTER GAF
  , ("0a", '\x06F0')    -- EXTENDED ARABIC-INDIC DIGIT ZERO
  , ("1a", '\x06F1')    -- EXTENDED ARABIC-INDIC DIGIT ONE
  , ("2a", '\x06F2')    -- EXTENDED ARABIC-INDIC DIGIT TWO
  , ("3a", '\x06F3')    -- EXTENDED ARABIC-INDIC DIGIT THREE
  , ("4a", '\x06F4')    -- EXTENDED ARABIC-INDIC DIGIT FOUR
  , ("5a", '\x06F5')    -- EXTENDED ARABIC-INDIC DIGIT FIVE
  , ("6a", '\x06F6')    -- EXTENDED ARABIC-INDIC DIGIT SIX
  , ("7a", '\x06F7')    -- EXTENDED ARABIC-INDIC DIGIT SEVEN
  , ("8a", '\x06F8')    -- EXTENDED ARABIC-INDIC DIGIT EIGHT
  , ("9a", '\x06F9')    -- EXTENDED ARABIC-INDIC DIGIT NINE
  , ("B.", '\x1E02')    -- LATIN CAPITAL LETTER B WITH DOT ABOVE
  , ("b.", '\x1E03')    -- LATIN SMALL LETTER B WITH DOT ABOVE
  , ("B_", '\x1E06')    -- LATIN CAPITAL LETTER B WITH LINE BELOW
  , ("b_", '\x1E07')    -- LATIN SMALL LETTER B WITH LINE BELOW
  , ("D.", '\x1E0A')    -- LATIN CAPITAL LETTER D WITH DOT ABOVE
  , ("d.", '\x1E0B')    -- LATIN SMALL LETTER D WITH DOT ABOVE
  , ("D_", '\x1E0E')    -- LATIN CAPITAL LETTER D WITH LINE BELOW
  , ("d_", '\x1E0F')    -- LATIN SMALL LETTER D WITH LINE BELOW
  , ("D,", '\x1E10')    -- LATIN CAPITAL LETTER D WITH CEDILLA
  , ("d,", '\x1E11')    -- LATIN SMALL LETTER D WITH CEDILLA
  , ("F.", '\x1E1E')    -- LATIN CAPITAL LETTER F WITH DOT ABOVE
  , ("f.", '\x1E1F')    -- LATIN SMALL LETTER F WITH DOT ABOVE
  , ("G-", '\x1E20')    -- LATIN CAPITAL LETTER G WITH MACRON
  , ("g-", '\x1E21')    -- LATIN SMALL LETTER G WITH MACRON
  , ("H.", '\x1E22')    -- LATIN CAPITAL LETTER H WITH DOT ABOVE
  , ("h.", '\x1E23')    -- LATIN SMALL LETTER H WITH DOT ABOVE
  , ("H:", '\x1E26')    -- LATIN CAPITAL LETTER H WITH DIAERESIS
  , ("h:", '\x1E27')    -- LATIN SMALL LETTER H WITH DIAERESIS
  , ("H,", '\x1E28')    -- LATIN CAPITAL LETTER H WITH CEDILLA
  , ("h,", '\x1E29')    -- LATIN SMALL LETTER H WITH CEDILLA
  , ("K'", '\x1E30')    -- LATIN CAPITAL LETTER K WITH ACUTE
  , ("k'", '\x1E31')    -- LATIN SMALL LETTER K WITH ACUTE
  , ("K_", '\x1E34')    -- LATIN CAPITAL LETTER K WITH LINE BELOW
  , ("k_", '\x1E35')    -- LATIN SMALL LETTER K WITH LINE BELOW
  , ("L_", '\x1E3A')    -- LATIN CAPITAL LETTER L WITH LINE BELOW
  , ("l_", '\x1E3B')    -- LATIN SMALL LETTER L WITH LINE BELOW
  , ("M'", '\x1E3E')    -- LATIN CAPITAL LETTER M WITH ACUTE
  , ("m'", '\x1E3F')    -- LATIN SMALL LETTER M WITH ACUTE
  , ("M.", '\x1E40')    -- LATIN CAPITAL LETTER M WITH DOT ABOVE
  , ("m.", '\x1E41')    -- LATIN SMALL LETTER M WITH DOT ABOVE
  , ("N.", '\x1E44')    -- LATIN CAPITAL LETTER N WITH DOT ABOVE `
  , ("n.", '\x1E45')    -- LATIN SMALL LETTER N WITH DOT ABOVE `
  , ("N_", '\x1E48')    -- LATIN CAPITAL LETTER N WITH LINE BELOW `
  , ("n_", '\x1E49')    -- LATIN SMALL LETTER N WITH LINE BELOW `
  , ("P'", '\x1E54')    -- LATIN CAPITAL LETTER P WITH ACUTE
  , ("p'", '\x1E55')    -- LATIN SMALL LETTER P WITH ACUTE
  , ("P.", '\x1E56')    -- LATIN CAPITAL LETTER P WITH DOT ABOVE
  , ("p.", '\x1E57')    -- LATIN SMALL LETTER P WITH DOT ABOVE
  , ("R.", '\x1E58')    -- LATIN CAPITAL LETTER R WITH DOT ABOVE
  , ("r.", '\x1E59')    -- LATIN SMALL LETTER R WITH DOT ABOVE
  , ("R_", '\x1E5E')    -- LATIN CAPITAL LETTER R WITH LINE BELOW
  , ("r_", '\x1E5F')    -- LATIN SMALL LETTER R WITH LINE BELOW
  , ("S.", '\x1E60')    -- LATIN CAPITAL LETTER S WITH DOT ABOVE
  , ("s.", '\x1E61')    -- LATIN SMALL LETTER S WITH DOT ABOVE
  , ("T.", '\x1E6A')    -- LATIN CAPITAL LETTER T WITH DOT ABOVE
  , ("t.", '\x1E6B')    -- LATIN SMALL LETTER T WITH DOT ABOVE
  , ("T_", '\x1E6E')    -- LATIN CAPITAL LETTER T WITH LINE BELOW
  , ("t_", '\x1E6F')    -- LATIN SMALL LETTER T WITH LINE BELOW
  , ("V?", '\x1E7C')    -- LATIN CAPITAL LETTER V WITH TILDE
  , ("v?", '\x1E7D')    -- LATIN SMALL LETTER V WITH TILDE
  , ("W!", '\x1E80')    -- LATIN CAPITAL LETTER W WITH GRAVE
  , ("w!", '\x1E81')    -- LATIN SMALL LETTER W WITH GRAVE
  , ("W'", '\x1E82')    -- LATIN CAPITAL LETTER W WITH ACUTE
  , ("w'", '\x1E83')    -- LATIN SMALL LETTER W WITH ACUTE
  , ("W:", '\x1E84')    -- LATIN CAPITAL LETTER W WITH DIAERESIS
  , ("w:", '\x1E85')    -- LATIN SMALL LETTER W WITH DIAERESIS
  , ("W.", '\x1E86')    -- LATIN CAPITAL LETTER W WITH DOT ABOVE
  , ("w.", '\x1E87')    -- LATIN SMALL LETTER W WITH DOT ABOVE
  , ("X.", '\x1E8A')    -- LATIN CAPITAL LETTER X WITH DOT ABOVE
  , ("x.", '\x1E8B')    -- LATIN SMALL LETTER X WITH DOT ABOVE
  , ("X:", '\x1E8C')    -- LATIN CAPITAL LETTER X WITH DIAERESIS
  , ("x:", '\x1E8D')    -- LATIN SMALL LETTER X WITH DIAERESIS
  , ("Y.", '\x1E8E')    -- LATIN CAPITAL LETTER Y WITH DOT ABOVE
  , ("y.", '\x1E8F')    -- LATIN SMALL LETTER Y WITH DOT ABOVE
  , ("Z>", '\x1E90')    -- LATIN CAPITAL LETTER Z WITH CIRCUMFLEX
  , ("z>", '\x1E91')    -- LATIN SMALL LETTER Z WITH CIRCUMFLEX
  , ("Z_", '\x1E94')    -- LATIN CAPITAL LETTER Z WITH LINE BELOW
  , ("z_", '\x1E95')    -- LATIN SMALL LETTER Z WITH LINE BELOW
  , ("h_", '\x1E96')    -- LATIN SMALL LETTER H WITH LINE BELOW
  , ("t:", '\x1E97')    -- LATIN SMALL LETTER T WITH DIAERESIS
  , ("w0", '\x1E98')    -- LATIN SMALL LETTER W WITH RING ABOVE
  , ("y0", '\x1E99')    -- LATIN SMALL LETTER Y WITH RING ABOVE
  , ("A2", '\x1EA2')    -- LATIN CAPITAL LETTER A WITH HOOK ABOVE
  , ("a2", '\x1EA3')    -- LATIN SMALL LETTER A WITH HOOK ABOVE
  , ("E2", '\x1EBA')    -- LATIN CAPITAL LETTER E WITH HOOK ABOVE
  , ("e2", '\x1EBB')    -- LATIN SMALL LETTER E WITH HOOK ABOVE
  , ("E?", '\x1EBC')    -- LATIN CAPITAL LETTER E WITH TILDE
  , ("e?", '\x1EBD')    -- LATIN SMALL LETTER E WITH TILDE
  , ("I2", '\x1EC8')    -- LATIN CAPITAL LETTER I WITH HOOK ABOVE
  , ("i2", '\x1EC9')    -- LATIN SMALL LETTER I WITH HOOK ABOVE
  , ("O2", '\x1ECE')    -- LATIN CAPITAL LETTER O WITH HOOK ABOVE
  , ("o2", '\x1ECF')    -- LATIN SMALL LETTER O WITH HOOK ABOVE
  , ("U2", '\x1EE6')    -- LATIN CAPITAL LETTER U WITH HOOK ABOVE
  , ("u2", '\x1EE7')    -- LATIN SMALL LETTER U WITH HOOK ABOVE
  , ("Y!", '\x1EF2')    -- LATIN CAPITAL LETTER Y WITH GRAVE
  , ("y!", '\x1EF3')    -- LATIN SMALL LETTER Y WITH GRAVE
  , ("Y2", '\x1EF6')    -- LATIN CAPITAL LETTER Y WITH HOOK ABOVE
  , ("y2", '\x1EF7')    -- LATIN SMALL LETTER Y WITH HOOK ABOVE
  , ("Y?", '\x1EF8')    -- LATIN CAPITAL LETTER Y WITH TILDE
  , ("y?", '\x1EF9')    -- LATIN SMALL LETTER Y WITH TILDE
  , (";'", '\x1F00')    -- GREEK SMALL LETTER ALPHA WITH PSILI
  , (",'", '\x1F01')    -- GREEK SMALL LETTER ALPHA WITH DASIA
  , (";!", '\x1F02')    -- GREEK SMALL LETTER ALPHA WITH PSILI AND VARIA
  , (",!", '\x1F03')    -- GREEK SMALL LETTER ALPHA WITH DASIA AND VARIA
  , ("?;", '\x1F04')    -- GREEK SMALL LETTER ALPHA WITH PSILI AND OXIA
  , ("?,", '\x1F05')    -- GREEK SMALL LETTER ALPHA WITH DASIA AND OXIA
  , ("!:", '\x1F06')    -- GREEK SMALL LETTER ALPHA WITH PSILI AND PERISPOMENI
  , ("?:", '\x1F07')    -- GREEK SMALL LETTER ALPHA WITH DASIA AND PERISPOMENI
  , ("1N", '\x2002')    -- EN SPACE
  , ("1M", '\x2003')    -- EM SPACE
  , ("3M", '\x2004')    -- THREE-PER-EM SPACE
  , ("4M", '\x2005')    -- FOUR-PER-EM SPACE
  , ("6M", '\x2006')    -- SIX-PER-EM SPACE
  , ("1T", '\x2009')    -- THIN SPACE
  , ("1H", '\x200A')    -- HAIR SPACE
  , ("-1", '\x2010')    -- HYPHEN
  , ("-N", '\x2013')    -- EN DASH `
  , ("-M", '\x2014')    -- EM DASH
  , ("-3", '\x2015')    -- HORIZONTAL BAR
  , ("!2", '\x2016')    -- DOUBLE VERTICAL LINE
  , ("=2", '\x2017')    -- DOUBLE LOW LINE
  , ("'6", '\x2018')    -- LEFT SINGLE QUOTATION MARK
  , ("'9", '\x2019')    -- RIGHT SINGLE QUOTATION MARK
  , (".9", '\x201A')    -- SINGLE LOW-9 QUOTATION MARK
  , ("9'", '\x201B')    -- SINGLE HIGH-REVERSED-9 QUOTATION MARK
  , ("\"6", '\x201C')   -- LEFT DOUBLE QUOTATION MARK
  , ("\"9", '\x201D')   -- RIGHT DOUBLE QUOTATION MARK
  , (":9", '\x201E')    -- DOUBLE LOW-9 QUOTATION MARK
  , ("9\"", '\x201F')   -- DOUBLE HIGH-REVERSED-9 QUOTATION MARK
  , ("/-", '\x2020')    -- DAGGER
  , ("/=", '\x2021')    -- DOUBLE DAGGER
  , ("..", '\x2025')    -- TWO DOT LEADER
  , ("%0", '\x2030')    -- PER MILLE SIGN
  , ("1'", '\x2032')    -- PRIME
  , ("2'", '\x2033')    -- DOUBLE PRIME
  , ("3'", '\x2034')    -- TRIPLE PRIME
  , ("1\"", '\x2035')   -- REVERSED PRIME
  , ("2\"", '\x2036')   -- REVERSED DOUBLE PRIME
  , ("3\"", '\x2037')   -- REVERSED TRIPLE PRIME
  , ("Ca", '\x2038')    -- CARET
  , ("<1", '\x2039')    -- SINGLE LEFT-POINTING ANGLE QUOTATION MARK
  , (">1", '\x203A')    -- SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
  , (":X", '\x203B')    -- REFERENCE MARK
  , ("'-", '\x203E')    -- OVERLINE
  , ("/f", '\x2044')    -- FRACTION SLASH
  , ("0S", '\x2070')    -- SUPERSCRIPT ZERO
  , ("4S", '\x2074')    -- SUPERSCRIPT FOUR
  , ("5S", '\x2075')    -- SUPERSCRIPT FIVE
  , ("6S", '\x2076')    -- SUPERSCRIPT SIX
  , ("7S", '\x2077')    -- SUPERSCRIPT SEVEN
  , ("8S", '\x2078')    -- SUPERSCRIPT EIGHT
  , ("9S", '\x2079')    -- SUPERSCRIPT NINE
  , ("+S", '\x207A')    -- SUPERSCRIPT PLUS SIGN
  , ("-S", '\x207B')    -- SUPERSCRIPT MINUS
  , ("=S", '\x207C')    -- SUPERSCRIPT EQUALS SIGN
  , ("(S", '\x207D')    -- SUPERSCRIPT LEFT PARENTHESIS
  , (")S", '\x207E')    -- SUPERSCRIPT RIGHT PARENTHESIS
  , ("nS", '\x207F')    -- SUPERSCRIPT LATIN SMALL LETTER N `
  , ("0s", '\x2080')    -- SUBSCRIPT ZERO
  , ("1s", '\x2081')    -- SUBSCRIPT ONE
  , ("2s", '\x2082')    -- SUBSCRIPT TWO
  , ("3s", '\x2083')    -- SUBSCRIPT THREE
  , ("4s", '\x2084')    -- SUBSCRIPT FOUR
  , ("5s", '\x2085')    -- SUBSCRIPT FIVE
  , ("6s", '\x2086')    -- SUBSCRIPT SIX
  , ("7s", '\x2087')    -- SUBSCRIPT SEVEN
  , ("8s", '\x2088')    -- SUBSCRIPT EIGHT
  , ("9s", '\x2089')    -- SUBSCRIPT NINE
  , ("+s", '\x208A')    -- SUBSCRIPT PLUS SIGN
  , ("-s", '\x208B')    -- SUBSCRIPT MINUS
  , ("=s", '\x208C')    -- SUBSCRIPT EQUALS SIGN
  , ("(s", '\x208D')    -- SUBSCRIPT LEFT PARENTHESIS
  , (")s", '\x208E')    -- SUBSCRIPT RIGHT PARENTHESIS
  , ("Li", '\x20A4')    -- LIRA SIGN
  , ("Pt", '\x20A7')    -- PESETA SIGN
  , ("W=", '\x20A9')    -- WON SIGN
  , ("Eu", '\x20AC')    -- EURO SIGN
  , ("oC", '\x2103')    -- DEGREE CELSIUS
  , ("co", '\x2105')    -- CARE OF
  , ("oF", '\x2109')    -- DEGREE FAHRENHEIT
  , ("N0", '\x2116')    -- NUMERO SIGN
  , ("PO", '\x2117')    -- SOUND RECORDING COPYRIGHT
  , ("Rx", '\x211E')    -- PRESCRIPTION TAKE
  , ("SM", '\x2120')    -- SERVICE MARK
  , ("TM", '\x2122')    -- TRADE MARK SIGN
  , ("Om", '\x2126')    -- OHM SIGN
  , ("AO", '\x212B')    -- ANGSTROM SIGN
  , ("13", '\x2153')    -- VULGAR FRACTION ONE THIRD
  , ("23", '\x2154')    -- VULGAR FRACTION TWO THIRDS
  , ("15", '\x2155')    -- VULGAR FRACTION ONE FIFTH
  , ("25", '\x2156')    -- VULGAR FRACTION TWO FIFTHS
  , ("35", '\x2157')    -- VULGAR FRACTION THREE FIFTHS
  , ("45", '\x2158')    -- VULGAR FRACTION FOUR FIFTHS
  , ("16", '\x2159')    -- VULGAR FRACTION ONE SIXTH
  , ("56", '\x215A')    -- VULGAR FRACTION FIVE SIXTHS
  , ("18", '\x215B')    -- VULGAR FRACTION ONE EIGHTH
  , ("38", '\x215C')    -- VULGAR FRACTION THREE EIGHTHS
  , ("58", '\x215D')    -- VULGAR FRACTION FIVE EIGHTHS
  , ("78", '\x215E')    -- VULGAR FRACTION SEVEN EIGHTHS
  , ("1R", '\x2160')    -- ROMAN NUMERAL ONE
  , ("2R", '\x2161')    -- ROMAN NUMERAL TWO
  , ("3R", '\x2162')    -- ROMAN NUMERAL THREE
  , ("4R", '\x2163')    -- ROMAN NUMERAL FOUR
  , ("5R", '\x2164')    -- ROMAN NUMERAL FIVE
  , ("6R", '\x2165')    -- ROMAN NUMERAL SIX
  , ("7R", '\x2166')    -- ROMAN NUMERAL SEVEN
  , ("8R", '\x2167')    -- ROMAN NUMERAL EIGHT
  , ("9R", '\x2168')    -- ROMAN NUMERAL NINE
  , ("aR", '\x2169')    -- ROMAN NUMERAL TEN
  , ("bR", '\x216A')    -- ROMAN NUMERAL ELEVEN
  , ("cR", '\x216B')    -- ROMAN NUMERAL TWELVE
  , ("1r", '\x2170')    -- SMALL ROMAN NUMERAL ONE
  , ("2r", '\x2171')    -- SMALL ROMAN NUMERAL TWO
  , ("3r", '\x2172')    -- SMALL ROMAN NUMERAL THREE
  , ("4r", '\x2173')    -- SMALL ROMAN NUMERAL FOUR
  , ("5r", '\x2174')    -- SMALL ROMAN NUMERAL FIVE
  , ("6r", '\x2175')    -- SMALL ROMAN NUMERAL SIX
  , ("7r", '\x2176')    -- SMALL ROMAN NUMERAL SEVEN
  , ("8r", '\x2177')    -- SMALL ROMAN NUMERAL EIGHT
  , ("9r", '\x2178')    -- SMALL ROMAN NUMERAL NINE
  , ("ar", '\x2179')    -- SMALL ROMAN NUMERAL TEN
  , ("br", '\x217A')    -- SMALL ROMAN NUMERAL ELEVEN
  , ("cr", '\x217B')    -- SMALL ROMAN NUMERAL TWELVE
  , ("<-", '\x2190')    -- LEFTWARDS ARROW
  , ("-!", '\x2191')    -- UPWARDS ARROW
  , ("->", '\x2192')    -- RIGHTWARDS ARROW
  , ("-v", '\x2193')    -- DOWNWARDS ARROW
  , ("<>", '\x2194')    -- LEFT RIGHT ARROW
  , ("UD", '\x2195')    -- UP DOWN ARROW
  , ("<=", '\x21D0')    -- LEFTWARDS DOUBLE ARROW
  , ("=>", '\x21D2')    -- RIGHTWARDS DOUBLE ARROW
  , ("==", '\x21D4')    -- LEFT RIGHT DOUBLE ARROW
  , ("FA", '\x2200')    -- FOR ALL
  , ("dP", '\x2202')    -- PARTIAL DIFFERENTIAL
  , ("TE", '\x2203')    -- THERE EXISTS
  , ("/0", '\x2205')    -- EMPTY SET
  , ("DE", '\x2206')    -- INCREMENT
  , ("NB", '\x2207')    -- NABLA
  , ("(-", '\x2208')    -- ELEMENT OF
  , ("-)", '\x220B')    -- CONTAINS AS MEMBER
  , ("*P", '\x220F')    -- N-ARY PRODUCT `
  , ("+Z", '\x2211')    -- N-ARY SUMMATION `
  , ("-2", '\x2212')    -- MINUS SIGN
  , ("-+", '\x2213')    -- MINUS-OR-PLUS SIGN
  , ("*-", '\x2217')    -- ASTERISK OPERATOR
  , ("Ob", '\x2218')    -- RING OPERATOR
  , ("Sb", '\x2219')    -- BULLET OPERATOR
  , ("RT", '\x221A')    -- SQUARE ROOT
  , ("0(", '\x221D')    -- PROPORTIONAL TO
  , ("00", '\x221E')    -- INFINITY
  , ("-L", '\x221F')    -- RIGHT ANGLE
  , ("-V", '\x2220')    -- ANGLE
  , ("PP", '\x2225')    -- PARALLEL TO
  , ("AN", '\x2227')    -- LOGICAL AND
  , ("OR", '\x2228')    -- LOGICAL OR
  , ("(U", '\x2229')    -- INTERSECTION
  , (")U", '\x222A')    -- UNION
  , ("In", '\x222B')    -- INTEGRAL
  , ("DI", '\x222C')    -- DOUBLE INTEGRAL
  , ("Io", '\x222E')    -- CONTOUR INTEGRAL
  , (".:", '\x2234')    -- THEREFORE
  , (":.", '\x2235')    -- BECAUSE
  , (":R", '\x2236')    -- RATIO
  , ("::", '\x2237')    -- PROPORTION
  , ("?1", '\x223C')    -- TILDE OPERATOR
  , ("CG", '\x223E')    -- INVERTED LAZY S
  , ("?-", '\x2243')    -- ASYMPTOTICALLY EQUAL TO
  , ("?=", '\x2245')    -- APPROXIMATELY EQUAL TO
  , ("?2", '\x2248')    -- ALMOST EQUAL TO
  , ("=?", '\x224C')    -- ALL EQUAL TO
  , ("HI", '\x2253')    -- IMAGE OF OR APPROXIMATELY EQUAL TO
  , ("!=", '\x2260')    -- NOT EQUAL TO
  , ("=3", '\x2261')    -- IDENTICAL TO
  , ("=<", '\x2264')    -- LESS-THAN OR EQUAL TO
  , (">=", '\x2265')    -- GREATER-THAN OR EQUAL TO
  , ("<*", '\x226A')    -- MUCH LESS-THAN
  , ("*>", '\x226B')    -- MUCH GREATER-THAN
  , ("!<", '\x226E')    -- NOT LESS-THAN
  , ("!>", '\x226F')    -- NOT GREATER-THAN
  , ("(C", '\x2282')    -- SUBSET OF
  , (")C", '\x2283')    -- SUPERSET OF
  , ("(_", '\x2286')    -- SUBSET OF OR EQUAL TO
  , (")_", '\x2287')    -- SUPERSET OF OR EQUAL TO
  , ("0.", '\x2299')    -- CIRCLED DOT OPERATOR
  , ("02", '\x229A')    -- CIRCLED RING OPERATOR
  , ("-T", '\x22A5')    -- UP TACK
  , (".P", '\x22C5')    -- DOT OPERATOR
  , (":3", '\x22EE')    -- VERTICAL ELLIPSIS
  , (".3", '\x22EF')    -- MIDLINE HORIZONTAL ELLIPSIS
  , ("Eh", '\x2302')    -- HOUSE
  , ("<7", '\x2308')    -- LEFT CEILING
  , (">7", '\x2309')    -- RIGHT CEILING
  , ("7<", '\x230A')    -- LEFT FLOOR
  , ("7>", '\x230B')    -- RIGHT FLOOR
  , ("NI", '\x2310')    -- REVERSED NOT SIGN
  , ("(A", '\x2312')    -- ARC
  , ("TR", '\x2315')    -- TELEPHONE RECORDER
  , ("Iu", '\x2320')    -- TOP HALF INTEGRAL
  , ("Il", '\x2321')    -- BOTTOM HALF INTEGRAL
  , ("</", '\x2329')    -- LEFT-POINTING ANGLE BRACKET
  , ("/>", '\x232A')    -- RIGHT-POINTING ANGLE BRACKET
  , ("Vs", '\x2423')    -- OPEN BOX
  , ("1h", '\x2440')    -- OCR HOOK
  , ("3h", '\x2441')    -- OCR CHAIR
  , ("2h", '\x2442')    -- OCR FORK
  , ("4h", '\x2443')    -- OCR INVERTED FORK
  , ("1j", '\x2446')    -- OCR BRANCH BANK IDENTIFICATION
  , ("2j", '\x2447')    -- OCR AMOUNT OF CHECK
  , ("3j", '\x2448')    -- OCR DASH
  , ("4j", '\x2449')    -- OCR CUSTOMER ACCOUNT NUMBER
  , ("1.", '\x2488')    -- DIGIT ONE FULL STOP
  , ("2.", '\x2489')    -- DIGIT TWO FULL STOP
  , ("3.", '\x248A')    -- DIGIT THREE FULL STOP
  , ("4.", '\x248B')    -- DIGIT FOUR FULL STOP
  , ("5.", '\x248C')    -- DIGIT FIVE FULL STOP
  , ("6.", '\x248D')    -- DIGIT SIX FULL STOP
  , ("7.", '\x248E')    -- DIGIT SEVEN FULL STOP
  , ("8.", '\x248F')    -- DIGIT EIGHT FULL STOP
  , ("9.", '\x2490')    -- DIGIT NINE FULL STOP
  , ("hh", '\x2500')    -- BOX DRAWINGS LIGHT HORIZONTAL
  , ("HH", '\x2501')    -- BOX DRAWINGS HEAVY HORIZONTAL
  , ("vv", '\x2502')    -- BOX DRAWINGS LIGHT VERTICAL
  , ("VV", '\x2503')    -- BOX DRAWINGS HEAVY VERTICAL
  , ("3-", '\x2504')    -- BOX DRAWINGS LIGHT TRIPLE DASH HORIZONTAL
  , ("3_", '\x2505')    -- BOX DRAWINGS HEAVY TRIPLE DASH HORIZONTAL
  , ("3!", '\x2506')    -- BOX DRAWINGS LIGHT TRIPLE DASH VERTICAL
  , ("3/", '\x2507')    -- BOX DRAWINGS HEAVY TRIPLE DASH VERTICAL
  , ("4-", '\x2508')    -- BOX DRAWINGS LIGHT QUADRUPLE DASH HORIZONTAL
  , ("4_", '\x2509')    -- BOX DRAWINGS HEAVY QUADRUPLE DASH HORIZONTAL
  , ("4!", '\x250A')    -- BOX DRAWINGS LIGHT QUADRUPLE DASH VERTICAL
  , ("4/", '\x250B')    -- BOX DRAWINGS HEAVY QUADRUPLE DASH VERTICAL
  , ("dr", '\x250C')    -- BOX DRAWINGS LIGHT DOWN AND RIGHT
  , ("dR", '\x250D')    -- BOX DRAWINGS DOWN LIGHT AND RIGHT HEAVY
  , ("Dr", '\x250E')    -- BOX DRAWINGS DOWN HEAVY AND RIGHT LIGHT
  , ("DR", '\x250F')    -- BOX DRAWINGS HEAVY DOWN AND RIGHT
  , ("dl", '\x2510')    -- BOX DRAWINGS LIGHT DOWN AND LEFT
  , ("dL", '\x2511')    -- BOX DRAWINGS DOWN LIGHT AND LEFT HEAVY
  , ("Dl", '\x2512')    -- BOX DRAWINGS DOWN HEAVY AND LEFT LIGHT
  , ("LD", '\x2513')    -- BOX DRAWINGS HEAVY DOWN AND LEFT
  , ("ur", '\x2514')    -- BOX DRAWINGS LIGHT UP AND RIGHT
  , ("uR", '\x2515')    -- BOX DRAWINGS UP LIGHT AND RIGHT HEAVY
  , ("Ur", '\x2516')    -- BOX DRAWINGS UP HEAVY AND RIGHT LIGHT
  , ("UR", '\x2517')    -- BOX DRAWINGS HEAVY UP AND RIGHT
  , ("ul", '\x2518')    -- BOX DRAWINGS LIGHT UP AND LEFT
  , ("uL", '\x2519')    -- BOX DRAWINGS UP LIGHT AND LEFT HEAVY
  , ("Ul", '\x251A')    -- BOX DRAWINGS UP HEAVY AND LEFT LIGHT
  , ("UL", '\x251B')    -- BOX DRAWINGS HEAVY UP AND LEFT
  , ("vr", '\x251C')    -- BOX DRAWINGS LIGHT VERTICAL AND RIGHT
  , ("vR", '\x251D')    -- BOX DRAWINGS VERTICAL LIGHT AND RIGHT HEAVY
  , ("Vr", '\x2520')    -- BOX DRAWINGS VERTICAL HEAVY AND RIGHT LIGHT
  , ("VR", '\x2523')    -- BOX DRAWINGS HEAVY VERTICAL AND RIGHT
  , ("vl", '\x2524')    -- BOX DRAWINGS LIGHT VERTICAL AND LEFT
  , ("vL", '\x2525')    -- BOX DRAWINGS VERTICAL LIGHT AND LEFT HEAVY
  , ("Vl", '\x2528')    -- BOX DRAWINGS VERTICAL HEAVY AND LEFT LIGHT
  , ("VL", '\x252B')    -- BOX DRAWINGS HEAVY VERTICAL AND LEFT
  , ("dh", '\x252C')    -- BOX DRAWINGS LIGHT DOWN AND HORIZONTAL
  , ("dH", '\x252F')    -- BOX DRAWINGS DOWN LIGHT AND HORIZONTAL HEAVY
  , ("Dh", '\x2530')    -- BOX DRAWINGS DOWN HEAVY AND HORIZONTAL LIGHT
  , ("DH", '\x2533')    -- BOX DRAWINGS HEAVY DOWN AND HORIZONTAL
  , ("uh", '\x2534')    -- BOX DRAWINGS LIGHT UP AND HORIZONTAL
  , ("uH", '\x2537')    -- BOX DRAWINGS UP LIGHT AND HORIZONTAL HEAVY
  , ("Uh", '\x2538')    -- BOX DRAWINGS UP HEAVY AND HORIZONTAL LIGHT
  , ("UH", '\x253B')    -- BOX DRAWINGS HEAVY UP AND HORIZONTAL
  , ("vh", '\x253C')    -- BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL
  , ("vH", '\x253F')    -- BOX DRAWINGS VERTICAL LIGHT AND HORIZONTAL HEAVY
  , ("Vh", '\x2542')    -- BOX DRAWINGS VERTICAL HEAVY AND HORIZONTAL LIGHT
  , ("VH", '\x254B')    -- BOX DRAWINGS HEAVY VERTICAL AND HORIZONTAL
  , ("FD", '\x2571')    -- BOX DRAWINGS LIGHT DIAGONAL UPPER RIGHT TO LOWER LEFT
  , ("BD", '\x2572')    -- BOX DRAWINGS LIGHT DIAGONAL UPPER LEFT TO LOWER RIGHT
  , ("TB", '\x2580')    -- UPPER HALF BLOCK
  , ("LB", '\x2584')    -- LOWER HALF BLOCK
  , ("FB", '\x2588')    -- FULL BLOCK
  , ("lB", '\x258C')    -- LEFT HALF BLOCK
  , ("RB", '\x2590')    -- RIGHT HALF BLOCK
  , (".S", '\x2591')    -- LIGHT SHADE
  , (":S", '\x2592')    -- MEDIUM SHADE
  , ("?S", '\x2593')    -- DARK SHADE
  , ("fS", '\x25A0')    -- BLACK SQUARE
  , ("OS", '\x25A1')    -- WHITE SQUARE
  , ("RO", '\x25A2')    -- WHITE SQUARE WITH ROUNDED CORNERS
  , ("Rr", '\x25A3')    -- WHITE SQUARE CONTAINING BLACK SMALL SQUARE
  , ("RF", '\x25A4')    -- SQUARE WITH HORIZONTAL FILL
  , ("RY", '\x25A5')    -- SQUARE WITH VERTICAL FILL
  , ("RH", '\x25A6')    -- SQUARE WITH ORTHOGONAL CROSSHATCH FILL
  , ("RZ", '\x25A7')    -- SQUARE WITH UPPER LEFT TO LOWER RIGHT FILL
  , ("RK", '\x25A8')    -- SQUARE WITH UPPER RIGHT TO LOWER LEFT FILL
  , ("RX", '\x25A9')    -- SQUARE WITH DIAGONAL CROSSHATCH FILL
  , ("sB", '\x25AA')    -- BLACK SMALL SQUARE
  , ("SR", '\x25AC')    -- BLACK RECTANGLE
  , ("Or", '\x25AD')    -- WHITE RECTANGLE
  , ("UT", '\x25B2')    -- BLACK UP-POINTING TRIANGLE
  , ("uT", '\x25B3')    -- WHITE UP-POINTING TRIANGLE
  , ("PR", '\x25B6')    -- BLACK RIGHT-POINTING TRIANGLE
  , ("Tr", '\x25B7')    -- WHITE RIGHT-POINTING TRIANGLE
  , ("Dt", '\x25BC')    -- BLACK DOWN-POINTING TRIANGLE
  , ("dT", '\x25BD')    -- WHITE DOWN-POINTING TRIANGLE
  , ("PL", '\x25C0')    -- BLACK LEFT-POINTING TRIANGLE
  , ("Tl", '\x25C1')    -- WHITE LEFT-POINTING TRIANGLE
  , ("Db", '\x25C6')    -- BLACK DIAMOND
  , ("Dw", '\x25C7')    -- WHITE DIAMOND
  , ("LZ", '\x25CA')    -- LOZENGE
  , ("0m", '\x25CB')    -- WHITE CIRCLE
  , ("0o", '\x25CE')    -- BULLSEYE
  , ("0M", '\x25CF')    -- BLACK CIRCLE
  , ("0L", '\x25D0')    -- CIRCLE WITH LEFT HALF BLACK
  , ("0R", '\x25D1')    -- CIRCLE WITH RIGHT HALF BLACK
  , ("Sn", '\x25D8')    -- INVERSE BULLET
  , ("Ic", '\x25D9')    -- INVERSE WHITE CIRCLE
  , ("Fd", '\x25E2')    -- BLACK LOWER RIGHT TRIANGLE
  , ("Bd", '\x25E3')    -- BLACK LOWER LEFT TRIANGLE
  , ("*2", '\x2605')    -- BLACK STAR
  , ("*1", '\x2606')    -- WHITE STAR
  , ("<H", '\x261C')    -- WHITE LEFT POINTING INDEX
  , (">H", '\x261E')    -- WHITE RIGHT POINTING INDEX
  , ("0u", '\x263A')    -- WHITE SMILING FACE
  , ("0U", '\x263B')    -- BLACK SMILING FACE
  , ("SU", '\x263C')    -- WHITE SUN WITH RAYS
  , ("Fm", '\x2640')    -- FEMALE SIGN
  , ("Ml", '\x2642')    -- MALE SIGN
  , ("cS", '\x2660')    -- BLACK SPADE SUIT
  , ("cH", '\x2661')    -- WHITE HEART SUIT
  , ("cD", '\x2662')    -- WHITE DIAMOND SUIT
  , ("cC", '\x2663')    -- BLACK CLUB SUIT
  , ("Md", '\x2669')    -- QUARTER NOTE `
  , ("M8", '\x266A')    -- EIGHTH NOTE `
  , ("M2", '\x266B')    -- BEAMED EIGHTH NOTES
  , ("Mb", '\x266D')    -- MUSIC FLAT SIGN
  , ("Mx", '\x266E')    -- MUSIC NATURAL SIGN
  , ("MX", '\x266F')    -- MUSIC SHARP SIGN
  , ("OK", '\x2713')    -- CHECK MARK
  , ("XX", '\x2717')    -- BALLOT X
  , ("-X", '\x2720')    -- MALTESE CROSS
  , ("IS", '\x3000')    -- IDEOGRAPHIC SPACE
  , (",_", '\x3001')    -- IDEOGRAPHIC COMMA
  , ("._", '\x3002')    -- IDEOGRAPHIC FULL STOP
  , ("+\"", '\x3003')   -- DITTO MARK
  , ("+_", '\x3004')    -- JAPANESE INDUSTRIAL STANDARD SYMBOL
  , ("*_", '\x3005')    -- IDEOGRAPHIC ITERATION MARK
  , (";_", '\x3006')    -- IDEOGRAPHIC CLOSING MARK
  , ("0_", '\x3007')    -- IDEOGRAPHIC NUMBER ZERO
  , ("<+", '\x300A')    -- LEFT DOUBLE ANGLE BRACKET
  , (">+", '\x300B')    -- RIGHT DOUBLE ANGLE BRACKET
  , ("<'", '\x300C')    -- LEFT CORNER BRACKET
  , (">'", '\x300D')    -- RIGHT CORNER BRACKET
  , ("<\"", '\x300E')   -- LEFT WHITE CORNER BRACKET
  , (">\"", '\x300F')   -- RIGHT WHITE CORNER BRACKET
  , ("(\"", '\x3010')   -- LEFT BLACK LENTICULAR BRACKET
  , (")\"", '\x3011')   -- RIGHT BLACK LENTICULAR BRACKET
  , ("=T", '\x3012')    -- POSTAL MARK
  , ("=_", '\x3013')    -- GETA MARK
  , ("('", '\x3014')    -- LEFT TORTOISE SHELL BRACKET
  , (")'", '\x3015')    -- RIGHT TORTOISE SHELL BRACKET
  , ("(I", '\x3016')    -- LEFT WHITE LENTICULAR BRACKET
  , (")I", '\x3017')    -- RIGHT WHITE LENTICULAR BRACKET
  , ("-?", '\x301C')    -- WAVE DASH
  , ("A5", '\x3041')    -- HIRAGANA LETTER SMALL A
  , ("a5", '\x3042')    -- HIRAGANA LETTER A
  , ("I5", '\x3043')    -- HIRAGANA LETTER SMALL I
  , ("i5", '\x3044')    -- HIRAGANA LETTER I
  , ("U5", '\x3045')    -- HIRAGANA LETTER SMALL U
  , ("u5", '\x3046')    -- HIRAGANA LETTER U
  , ("E5", '\x3047')    -- HIRAGANA LETTER SMALL E
  , ("e5", '\x3048')    -- HIRAGANA LETTER E
  , ("O5", '\x3049')    -- HIRAGANA LETTER SMALL O
  , ("o5", '\x304A')    -- HIRAGANA LETTER O
  , ("ka", '\x304B')    -- HIRAGANA LETTER KA
  , ("ga", '\x304C')    -- HIRAGANA LETTER GA
  , ("ki", '\x304D')    -- HIRAGANA LETTER KI
  , ("gi", '\x304E')    -- HIRAGANA LETTER GI
  , ("ku", '\x304F')    -- HIRAGANA LETTER KU
  , ("gu", '\x3050')    -- HIRAGANA LETTER GU
  , ("ke", '\x3051')    -- HIRAGANA LETTER KE
  , ("ge", '\x3052')    -- HIRAGANA LETTER GE
  , ("ko", '\x3053')    -- HIRAGANA LETTER KO
  , ("go", '\x3054')    -- HIRAGANA LETTER GO
  , ("sa", '\x3055')    -- HIRAGANA LETTER SA
  , ("za", '\x3056')    -- HIRAGANA LETTER ZA
  , ("si", '\x3057')    -- HIRAGANA LETTER SI
  , ("zi", '\x3058')    -- HIRAGANA LETTER ZI
  , ("su", '\x3059')    -- HIRAGANA LETTER SU
  , ("zu", '\x305A')    -- HIRAGANA LETTER ZU
  , ("se", '\x305B')    -- HIRAGANA LETTER SE
  , ("ze", '\x305C')    -- HIRAGANA LETTER ZE
  , ("so", '\x305D')    -- HIRAGANA LETTER SO
  , ("zo", '\x305E')    -- HIRAGANA LETTER ZO
  , ("ta", '\x305F')    -- HIRAGANA LETTER TA
  , ("da", '\x3060')    -- HIRAGANA LETTER DA
  , ("ti", '\x3061')    -- HIRAGANA LETTER TI
  , ("di", '\x3062')    -- HIRAGANA LETTER DI
  , ("tU", '\x3063')    -- HIRAGANA LETTER SMALL TU
  , ("tu", '\x3064')    -- HIRAGANA LETTER TU
  , ("du", '\x3065')    -- HIRAGANA LETTER DU
  , ("te", '\x3066')    -- HIRAGANA LETTER TE
  , ("de", '\x3067')    -- HIRAGANA LETTER DE
  , ("to", '\x3068')    -- HIRAGANA LETTER TO
  , ("do", '\x3069')    -- HIRAGANA LETTER DO
  , ("na", '\x306A')    -- HIRAGANA LETTER NA
  , ("ni", '\x306B')    -- HIRAGANA LETTER NI
  , ("nu", '\x306C')    -- HIRAGANA LETTER NU
  , ("ne", '\x306D')    -- HIRAGANA LETTER NE
  , ("no", '\x306E')    -- HIRAGANA LETTER NO
  , ("ha", '\x306F')    -- HIRAGANA LETTER HA
  , ("ba", '\x3070')    -- HIRAGANA LETTER BA
  , ("pa", '\x3071')    -- HIRAGANA LETTER PA
  , ("hi", '\x3072')    -- HIRAGANA LETTER HI
  , ("bi", '\x3073')    -- HIRAGANA LETTER BI
  , ("pi", '\x3074')    -- HIRAGANA LETTER PI
  , ("hu", '\x3075')    -- HIRAGANA LETTER HU
  , ("bu", '\x3076')    -- HIRAGANA LETTER BU
  , ("pu", '\x3077')    -- HIRAGANA LETTER PU
  , ("he", '\x3078')    -- HIRAGANA LETTER HE
  , ("be", '\x3079')    -- HIRAGANA LETTER BE
  , ("pe", '\x307A')    -- HIRAGANA LETTER PE
  , ("ho", '\x307B')    -- HIRAGANA LETTER HO
  , ("bo", '\x307C')    -- HIRAGANA LETTER BO
  , ("po", '\x307D')    -- HIRAGANA LETTER PO
  , ("ma", '\x307E')    -- HIRAGANA LETTER MA
  , ("mi", '\x307F')    -- HIRAGANA LETTER MI
  , ("mu", '\x3080')    -- HIRAGANA LETTER MU
  , ("me", '\x3081')    -- HIRAGANA LETTER ME
  , ("mo", '\x3082')    -- HIRAGANA LETTER MO
  , ("yA", '\x3083')    -- HIRAGANA LETTER SMALL YA
  , ("ya", '\x3084')    -- HIRAGANA LETTER YA
  , ("yU", '\x3085')    -- HIRAGANA LETTER SMALL YU
  , ("yu", '\x3086')    -- HIRAGANA LETTER YU
  , ("yO", '\x3087')    -- HIRAGANA LETTER SMALL YO
  , ("yo", '\x3088')    -- HIRAGANA LETTER YO
  , ("ra", '\x3089')    -- HIRAGANA LETTER RA
  , ("ri", '\x308A')    -- HIRAGANA LETTER RI
  , ("ru", '\x308B')    -- HIRAGANA LETTER RU
  , ("re", '\x308C')    -- HIRAGANA LETTER RE
  , ("ro", '\x308D')    -- HIRAGANA LETTER RO
  , ("wA", '\x308E')    -- HIRAGANA LETTER SMALL WA
  , ("wa", '\x308F')    -- HIRAGANA LETTER WA
  , ("wi", '\x3090')    -- HIRAGANA LETTER WI
  , ("we", '\x3091')    -- HIRAGANA LETTER WE
  , ("wo", '\x3092')    -- HIRAGANA LETTER WO
  , ("n5", '\x3093')    -- HIRAGANA LETTER N `
  , ("vu", '\x3094')    -- HIRAGANA LETTER VU
  , ("\"5", '\x309B')   -- KATAKANA-HIRAGANA VOICED SOUND MARK
  , ("05", '\x309C')    -- KATAKANA-HIRAGANA SEMI-VOICED SOUND MARK
  , ("*5", '\x309D')    -- HIRAGANA ITERATION MARK
  , ("+5", '\x309E')    -- HIRAGANA VOICED ITERATION MARK
  , ("a6", '\x30A1')    -- KATAKANA LETTER SMALL A
  , ("A6", '\x30A2')    -- KATAKANA LETTER A
  , ("i6", '\x30A3')    -- KATAKANA LETTER SMALL I
  , ("I6", '\x30A4')    -- KATAKANA LETTER I
  , ("u6", '\x30A5')    -- KATAKANA LETTER SMALL U
  , ("U6", '\x30A6')    -- KATAKANA LETTER U
  , ("e6", '\x30A7')    -- KATAKANA LETTER SMALL E
  , ("E6", '\x30A8')    -- KATAKANA LETTER E
  , ("o6", '\x30A9')    -- KATAKANA LETTER SMALL O
  , ("O6", '\x30AA')    -- KATAKANA LETTER O
  , ("Ka", '\x30AB')    -- KATAKANA LETTER KA
  , ("Ga", '\x30AC')    -- KATAKANA LETTER GA
  , ("Ki", '\x30AD')    -- KATAKANA LETTER KI
  , ("Gi", '\x30AE')    -- KATAKANA LETTER GI
  , ("Ku", '\x30AF')    -- KATAKANA LETTER KU
  , ("Gu", '\x30B0')    -- KATAKANA LETTER GU
  , ("Ke", '\x30B1')    -- KATAKANA LETTER KE
  , ("Ge", '\x30B2')    -- KATAKANA LETTER GE
  , ("Ko", '\x30B3')    -- KATAKANA LETTER KO
  , ("Go", '\x30B4')    -- KATAKANA LETTER GO
  , ("Sa", '\x30B5')    -- KATAKANA LETTER SA
  , ("Za", '\x30B6')    -- KATAKANA LETTER ZA
  , ("Si", '\x30B7')    -- KATAKANA LETTER SI
  , ("Zi", '\x30B8')    -- KATAKANA LETTER ZI
  , ("Su", '\x30B9')    -- KATAKANA LETTER SU
  , ("Zu", '\x30BA')    -- KATAKANA LETTER ZU
  , ("Se", '\x30BB')    -- KATAKANA LETTER SE
  , ("Ze", '\x30BC')    -- KATAKANA LETTER ZE
  , ("So", '\x30BD')    -- KATAKANA LETTER SO
  , ("Zo", '\x30BE')    -- KATAKANA LETTER ZO
  , ("Ta", '\x30BF')    -- KATAKANA LETTER TA
  , ("Da", '\x30C0')    -- KATAKANA LETTER DA
  , ("Ti", '\x30C1')    -- KATAKANA LETTER TI
  , ("Di", '\x30C2')    -- KATAKANA LETTER DI
  , ("TU", '\x30C3')    -- KATAKANA LETTER SMALL TU
  , ("Tu", '\x30C4')    -- KATAKANA LETTER TU
  , ("Du", '\x30C5')    -- KATAKANA LETTER DU
  , ("Te", '\x30C6')    -- KATAKANA LETTER TE
  , ("De", '\x30C7')    -- KATAKANA LETTER DE
  , ("To", '\x30C8')    -- KATAKANA LETTER TO
  , ("Do", '\x30C9')    -- KATAKANA LETTER DO
  , ("Na", '\x30CA')    -- KATAKANA LETTER NA
  , ("Ni", '\x30CB')    -- KATAKANA LETTER NI
  , ("Nu", '\x30CC')    -- KATAKANA LETTER NU
  , ("Ne", '\x30CD')    -- KATAKANA LETTER NE
  , ("No", '\x30CE')    -- KATAKANA LETTER NO
  , ("Ha", '\x30CF')    -- KATAKANA LETTER HA
  , ("Ba", '\x30D0')    -- KATAKANA LETTER BA
  , ("Pa", '\x30D1')    -- KATAKANA LETTER PA
  , ("Hi", '\x30D2')    -- KATAKANA LETTER HI
  , ("Bi", '\x30D3')    -- KATAKANA LETTER BI
  , ("Pi", '\x30D4')    -- KATAKANA LETTER PI
  , ("Hu", '\x30D5')    -- KATAKANA LETTER HU
  , ("Bu", '\x30D6')    -- KATAKANA LETTER BU
  , ("Pu", '\x30D7')    -- KATAKANA LETTER PU
  , ("He", '\x30D8')    -- KATAKANA LETTER HE
  , ("Be", '\x30D9')    -- KATAKANA LETTER BE
  , ("Pe", '\x30DA')    -- KATAKANA LETTER PE
  , ("Ho", '\x30DB')    -- KATAKANA LETTER HO
  , ("Bo", '\x30DC')    -- KATAKANA LETTER BO
  , ("Po", '\x30DD')    -- KATAKANA LETTER PO
  , ("Ma", '\x30DE')    -- KATAKANA LETTER MA
  , ("Mi", '\x30DF')    -- KATAKANA LETTER MI
  , ("Mu", '\x30E0')    -- KATAKANA LETTER MU
  , ("Me", '\x30E1')    -- KATAKANA LETTER ME
  , ("Mo", '\x30E2')    -- KATAKANA LETTER MO
  , ("YA", '\x30E3')    -- KATAKANA LETTER SMALL YA
  , ("Ya", '\x30E4')    -- KATAKANA LETTER YA
  , ("YU", '\x30E5')    -- KATAKANA LETTER SMALL YU
  , ("Yu", '\x30E6')    -- KATAKANA LETTER YU
  , ("YO", '\x30E7')    -- KATAKANA LETTER SMALL YO
  , ("Yo", '\x30E8')    -- KATAKANA LETTER YO
  , ("Ra", '\x30E9')    -- KATAKANA LETTER RA
  , ("Ri", '\x30EA')    -- KATAKANA LETTER RI
  , ("Ru", '\x30EB')    -- KATAKANA LETTER RU
  , ("Re", '\x30EC')    -- KATAKANA LETTER RE
  , ("Ro", '\x30ED')    -- KATAKANA LETTER RO
  , ("WA", '\x30EE')    -- KATAKANA LETTER SMALL WA
  , ("Wa", '\x30EF')    -- KATAKANA LETTER WA
  , ("Wi", '\x30F0')    -- KATAKANA LETTER WI
  , ("We", '\x30F1')    -- KATAKANA LETTER WE
  , ("Wo", '\x30F2')    -- KATAKANA LETTER WO
  , ("N6", '\x30F3')    -- KATAKANA LETTER N `
  , ("Vu", '\x30F4')    -- KATAKANA LETTER VU
  , ("KA", '\x30F5')    -- KATAKANA LETTER SMALL KA
  , ("KE", '\x30F6')    -- KATAKANA LETTER SMALL KE
  , ("Va", '\x30F7')    -- KATAKANA LETTER VA
  , ("Vi", '\x30F8')    -- KATAKANA LETTER VI
  , ("Ve", '\x30F9')    -- KATAKANA LETTER VE
  , ("Vo", '\x30FA')    -- KATAKANA LETTER VO
  , (".6", '\x30FB')    -- KATAKANA MIDDLE DOT
  , ("-6", '\x30FC')    -- KATAKANA-HIRAGANA PROLONGED SOUND MARK
  , ("*6", '\x30FD')    -- KATAKANA ITERATION MARK
  , ("+6", '\x30FE')    -- KATAKANA VOICED ITERATION MARK
  , ("b4", '\x3105')    -- BOPOMOFO LETTER B
  , ("p4", '\x3106')    -- BOPOMOFO LETTER P
  , ("m4", '\x3107')    -- BOPOMOFO LETTER M
  , ("f4", '\x3108')    -- BOPOMOFO LETTER F
  , ("d4", '\x3109')    -- BOPOMOFO LETTER D
  , ("t4", '\x310A')    -- BOPOMOFO LETTER T
  , ("n4", '\x310B')    -- BOPOMOFO LETTER N `
  , ("l4", '\x310C')    -- BOPOMOFO LETTER L
  , ("g4", '\x310D')    -- BOPOMOFO LETTER G
  , ("k4", '\x310E')    -- BOPOMOFO LETTER K
  , ("h4", '\x310F')    -- BOPOMOFO LETTER H
  , ("j4", '\x3110')    -- BOPOMOFO LETTER J
  , ("q4", '\x3111')    -- BOPOMOFO LETTER Q
  , ("x4", '\x3112')    -- BOPOMOFO LETTER X
  , ("zh", '\x3113')    -- BOPOMOFO LETTER ZH
  , ("ch", '\x3114')    -- BOPOMOFO LETTER CH
  , ("sh", '\x3115')    -- BOPOMOFO LETTER SH
  , ("r4", '\x3116')    -- BOPOMOFO LETTER R
  , ("z4", '\x3117')    -- BOPOMOFO LETTER Z
  , ("c4", '\x3118')    -- BOPOMOFO LETTER C
  , ("s4", '\x3119')    -- BOPOMOFO LETTER S
  , ("a4", '\x311A')    -- BOPOMOFO LETTER A
  , ("o4", '\x311B')    -- BOPOMOFO LETTER O
  , ("e4", '\x311C')    -- BOPOMOFO LETTER E
  , ("ai", '\x311E')    -- BOPOMOFO LETTER AI
  , ("ei", '\x311F')    -- BOPOMOFO LETTER EI
  , ("au", '\x3120')    -- BOPOMOFO LETTER AU
  , ("ou", '\x3121')    -- BOPOMOFO LETTER OU
  , ("an", '\x3122')    -- BOPOMOFO LETTER AN
  , ("en", '\x3123')    -- BOPOMOFO LETTER EN
  , ("aN", '\x3124')    -- BOPOMOFO LETTER ANG
  , ("eN", '\x3125')    -- BOPOMOFO LETTER ENG
  , ("er", '\x3126')    -- BOPOMOFO LETTER ER
  , ("i4", '\x3127')    -- BOPOMOFO LETTER I
  , ("u4", '\x3128')    -- BOPOMOFO LETTER U
  , ("iu", '\x3129')    -- BOPOMOFO LETTER IU
  , ("v4", '\x312A')    -- BOPOMOFO LETTER V
  , ("nG", '\x312B')    -- BOPOMOFO LETTER NG
  , ("gn", '\x312C')    -- BOPOMOFO LETTER GN
  , ("1c", '\x3220')    -- PARENTHESIZED IDEOGRAPH ONE
  , ("2c", '\x3221')    -- PARENTHESIZED IDEOGRAPH TWO
  , ("3c", '\x3222')    -- PARENTHESIZED IDEOGRAPH THREE
  , ("4c", '\x3223')    -- PARENTHESIZED IDEOGRAPH FOUR
  , ("5c", '\x3224')    -- PARENTHESIZED IDEOGRAPH FIVE
  , ("6c", '\x3225')    -- PARENTHESIZED IDEOGRAPH SIX
  , ("7c", '\x3226')    -- PARENTHESIZED IDEOGRAPH SEVEN
  , ("8c", '\x3227')    -- PARENTHESIZED IDEOGRAPH EIGHT
  , ("9c", '\x3228')    -- PARENTHESIZED IDEOGRAPH NINE
  , ("ff", '\xFB00')    -- LATIN SMALL LIGATURE FF
  , ("fi", '\xFB01')    -- LATIN SMALL LIGATURE FI
  , ("fl", '\xFB02')    -- LATIN SMALL LIGATURE FL
  , ("ft", '\xFB05')    -- LATIN SMALL LIGATURE LONG S T
  , ("st", '\xFB06')    -- LATIN SMALL LIGATURE ST
  ]

{-# LANGUAGE OverloadedStrings #-}
module Main where

import IdGenerator
import Data.ByteString.Char8  as BC (pack, unpack, concat)
import Web.Scotty
import Data.Text.Lazy as TL (pack, concat)
import Data.Text.Lazy.Encoding as LE
import Network.URI (parseAbsoluteURI)
import Control.Monad.IO.Class

import Data.Time.Clock.POSIX (getPOSIXTime)

-- keep increasing this number occationally to (once a year?)
deductSeconds = 1500000000 
main :: IO ()
main = scotty 8000 $ do 
  put "/"  $ do
    currentTime <- liftIO $ round <$> getPOSIXTime
    uri <- param "uri"
    case parseAbsoluteURI (BC.unpack uri) of
      Just _ -> do
        code <- return $  shortId2ByteString $ generate (NodeId 1) uri  (currentTime - deductSeconds) 
        text $ TL.pack $ show  code
      Nothing -> text $ TL.concat  [ "Invalid URI -  ", TL.pack $ show uri]

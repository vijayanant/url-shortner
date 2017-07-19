{-# LANGUAGE OverloadedStrings #-}
module Main where

import IdGenerator
import Data.ByteString.Char8  as BC (pack, unpack)
import Web.Scotty
import Data.Text.Lazy as TL
import Data.Text.Lazy.Encoding as LE
import Network.URI (parseAbsoluteURI)
import Control.Monad.IO.Class

main :: IO ()
main = scotty 8000 $ do 
  get "/"  $ do
    uri <- param "uri"
    case parseAbsoluteURI (TL.unpack uri) of
      Just u -> do 
        uriBS <- return $ BC.pack $ TL.unpack uri
        code <- return $  shortId2ByteString $ generate (NodeId 1) uriBS  10000 
        text $ TL.pack $ show  code
        {-text $ TL.concat ["Invalid URI -  ", uri]-}
      Nothing -> text $ TL.concat ["Invalid URI -  ", uri]

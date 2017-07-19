{-# LANGUAGE OverloadedStrings #-}
module Main where

import IdGenerator
import Data.ByteString
import Web.Scotty                     as S
import Data.Text.Lazy.Encoding        as LE
import Database.Redis                 as R
import Data.ByteString.Char8          as BC ( pack, unpack, concat)
import Data.Text.Lazy                 as TL ( pack, concat)
import Control.Monad.IO.Class         as MC ( liftIO)
import Network.URI                          ( parseAbsoluteURI)
import Data.Time.Clock.POSIX                ( getPOSIXTime)

-- keep increasing this number occationally to keep our numeric value to generate function small (once a year?)
deductSeconds = 1500000000 

main :: IO ()
main = do 
  conn <- liftIO $ R.connect R.defaultConnectInfo :: IO Connection
  scotty 8000 $ do 
    S.put "/"  $ do
      currentTime <- liftIO $ round <$> getPOSIXTime
      uri <- param "uri"
      case parseAbsoluteURI (BC.unpack uri) of
        Just _ -> do
          code <- return $ shortId2ByteString $ generate (NodeId 1) uri  (currentTime - deductSeconds) 
          res <- liftIO $ saveURI code uri conn
          text $ TL.pack $ show  code
        Nothing -> text $ TL.concat  [ "Invalid URI -  ", TL.pack $ show uri]
    S.get "/:shortCode" $ do
      shortCode <- param "shortCode"
      res <- liftIO $ retrieveURI shortCode conn
      case res of 
        Left reply -> text $ TL.pack (show reply)
        Right maybeURI -> case  maybeURI of
          Nothing -> text "Invalid short code. URI Not found"
          Just xs ->  text $ TL.pack (show xs)

saveURI :: ByteString -> ByteString -> Connection -> IO (Either Reply Status)
saveURI code uri conn = runRedis conn $ R.set code uri

retrieveURI :: ByteString -> Connection -> IO (Either Reply (Maybe ByteString))
retrieveURI code conn = runRedis conn $ R.get code 

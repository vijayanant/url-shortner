{-# LANGUAGE OverloadedStrings #-}

module WebServer (
  runServer,
)where

import IdGenerator
import Database                       as DB
import Web.Scotty                     as S
import Data.ByteString.Char8          as BC ( pack, unpack, concat)
import Data.Text.Lazy                 as TL ( Text, pack, concat)
import Control.Monad.IO.Class         as MC ( liftIO)
import Data.Text.Lazy.Encoding        as LE
import Network.URI                          ( parseAbsoluteURI)
import Data.Time.Clock.POSIX                ( getPOSIXTime)


-- keep increasing this number occationally to keep our numeric value to `generate` function small (once a year?)
deductSeconds :: Int
deductSeconds = 1500000000 

type Port = Int
type ServerId = Int

runServer :: DB.Connection -> Port -> ServerId -> IO ()
runServer conn httpPort serverId = scotty httpPort $ do 
  S.put "/"           $ putHandler conn serverId
  S.get "/:shortCode" $ getHandler conn

putHandler :: DB.Connection -> Int -> S.ActionM () 
putHandler conn serverId = do
  currentTime <- liftIO $ round <$> getPOSIXTime
  uri <- param "uri"
  case parseAbsoluteURI (BC.unpack uri) of
    Just _ -> do
      code <- return $ shortId2ByteString $ generate (getNodeId serverId) uri  (currentTime - deductSeconds) 
      res <- liftIO $ DB.saveURI code uri conn
      text $ TL.pack $ show  code
    Nothing -> text $ TL.concat  [ "Invalid URI -  ", TL.pack $ show uri]
    
getHandler :: DB.Connection -> S.ActionM ()
getHandler conn = do
  shortCode <- param "shortCode"
  res <- liftIO $ retrieveURI shortCode conn
  case res of
    Left reply -> text $ TL.pack (show reply)
    Right maybeURI -> case  maybeURI of
      Nothing -> text "Invalid short code. URI Not found"
      Just xs ->  text $ TL.pack (show xs)


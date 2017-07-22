{-# LANGUAGE OverloadedStrings #-}
module Main where

import WebServer 
import Database
import Control.Monad.IO.Class ( liftIO)

httpPort = 8000
serverId = 1

main :: IO ()
main = do 
  dbConn <- liftIO $ getDbConnection
  runServer dbConn httpPort serverId

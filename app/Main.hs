{-# LANGUAGE OverloadedStrings #-}
module Main where

import WebServer 
import Database
import Control.Monad.IO.Class ( liftIO)
import System.Environment (getArgs, getProgName)

data Settings = Settings 
  { httpPort :: Int 
  , dbHost   :: HostName 
  , dbPort   :: PortNumber 
  , serverId :: Int
  }

usage   = "<port> <db host> <db port> <server id>"

processArgs:: [String] -> Either String Settings
processArgs (port:dbhost:dbport:sid:[]) = Right $ Settings
  {  httpPort = read port   :: Int
  ,  dbHost   = dbhost      :: HostName
  ,  dbPort   = read dbport :: PortNumber
  ,  serverId = read sid    :: Int
  }
processArgs _  = Left usage 

main :: IO ()
main = do 
  args <- getArgs
  case (processArgs args ) of 
    Left e -> do 
      progName <- getProgName 
      putStrLn $  progName  ++ " " ++  e
    Right settings -> do 
      dbConn <- liftIO $ getDbConnection (dbHost settings ) (dbPort settings)
      runServer dbConn (httpPort settings) (serverId settings)

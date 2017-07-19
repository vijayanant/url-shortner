{-# LANGUAGE OverloadedStrings #-}


module IdGenerator  where

import Data.ByteString  as BS
import Web.Hashids      as H

alphabets = ['a'..'z'] ++ ['A'..'Z'] ++ ['0'..'9'] 

newtype NodeId  = NodeId Int deriving (Show)
newtype ShortId = ShortId ByteString deriving (Show)

nodeIdToInt :: NodeId -> Int
nodeIdToInt (NodeId id) = id

shortId2ByteString :: ShortId -> ByteString
shortId2ByteString (ShortId id) = id

generate:: NodeId -> ByteString -> Int -> ShortId
generate nodeid salt ts = ShortId $ H.encodeList context [id, timestamp]
  where  
    context = createHashidsContext salt 6 alphabets
    id = nodeIdToInt nodeid
    timestamp = fromIntegral ts

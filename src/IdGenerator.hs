module IdGenerator (
  NodeId,
  getNodeId,
  ShortId,
  shortId2ByteString,
  generate,
) where

import Data.ByteString  as BS
import Web.Hashids      as H

alphabets = ['a'..'z'] ++ ['A'..'Z'] ++ ['0'..'9'] 

newtype NodeId  = NodeId Int deriving (Show)
newtype ShortId = ShortId ByteString deriving (Show)

nodeId2Int :: NodeId -> Int
nodeId2Int (NodeId id) = id

getNodeId :: Int -> NodeId
getNodeId nodeid = NodeId nodeid

shortId2ByteString :: ShortId -> ByteString
shortId2ByteString (ShortId id) = id

generate:: NodeId -> ByteString -> Int -> ShortId
generate nodeid salt ts = ShortId $ H.encodeList context [id, timestamp]
  where  
    context = createHashidsContext salt 6 alphabets
    id = nodeId2Int nodeid
    timestamp = fromIntegral ts

module Database (
  getDbConnection,
  saveURI,
  retrieveURI,
 
   -- exposed so that we can write proper type signatures
  R.Connection,
  HostName,
  PortNumber
) where 

import Database.Redis as R
import Data.ByteString (ByteString)
import Network.Socket (HostName, PortNumber)

 
getDbConnection :: HostName -> PortNumber -> IO Connection
getDbConnection host port = do 
  R.checkedConnect R.defaultConnectInfo 
    { connectHost = host
    , connectPort = PortNumber port
    }

saveURI :: ByteString -> ByteString -> Connection -> IO (Either Reply Status)
saveURI code uri conn = runRedis conn $ R.set code uri

retrieveURI :: ByteString -> Connection -> IO (Either Reply (Maybe ByteString))
retrieveURI code conn = runRedis conn $ R.get code 

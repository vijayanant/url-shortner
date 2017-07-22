module Database (
  getDbConnection,
  saveURI,
  retrieveURI,
  R.Connection, -- exposed so that we can write proper type signatures 
) where 

import Database.Redis as R
import Data.ByteString

getDbConnection :: IO Connection
getDbConnection = R.connect R.defaultConnectInfo

saveURI :: ByteString -> ByteString -> Connection -> IO (Either Reply Status)
saveURI code uri conn = runRedis conn $ R.set code uri

retrieveURI :: ByteString -> Connection -> IO (Either Reply (Maybe ByteString))
retrieveURI code conn = runRedis conn $ R.get code 

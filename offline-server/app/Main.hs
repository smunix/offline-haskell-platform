module Main where
import           Control.Monad.Extra
import           Control.Monad.IO.Class
import qualified Data.ByteString.Char8        as BS
import           Data.List.Extra
import           Data.Tuple.Extra
import           Network.HTTP.Types
import           Network.Wai
import           Network.Wai.Handler.Warp
import           System.Directory
import           System.FilePath

import           Control.Monad.Trans.Resource
import qualified Data.Conduit                 as C
import           Data.Conduit.Binary
import           Network.Connection
import qualified Network.HTTP.Conduit         as C
import           Network.Socket

import           Lib

main :: IO ()
main = withSocketsDo $ do
  let
    port = 3000
  putStrLn $ "Listening on port " ++ show port
  run port $ \req f -> f =<< app req
    where
      app :: Request -> IO Response
      app req = do
        let
          want = tail $ BS.unpack $ rawPathInfo req <> rawQueryString req
          url = uncurry (++) $ first (++ ":/") $ break ('/' ==) want
          file = "mirror" </> want
        createDirectoryIfMissing True "mirror"
        putStrLn $ "wanted : " <> want
        putStrLn $ "file : " <> file
        return $ responseFile status200 [] file Nothing

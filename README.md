# url-shortner
A simple URL shortening service written in Haskell.

Uses Redis for persistance


##API

### Create short URI
    $curl -XPUT http://localhost:8000/?uri='http://google.com'
    "lVUapmW"

### Retrieve original URI for the short code
    $curl -XGET http://localhost:8000/lVUapmW
    "http://google.com"


## Build 
* clone repo

* `stack build`

* `stack exec url-shortner-exe <http port> <db host> <db port> <server id>`

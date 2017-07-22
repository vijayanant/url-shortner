# url-shortner
A simple URL shortening service written in Haskell.

Uses Redis for persistance

## APIs

### Create 
    $curl -XPUT http://localhost:8000/?uri='http://google.com'
    "lVUapmW"

### Retrieve
    $curl -XGET http://localhost:8000/lVUapmW
    "http://google.com"

## Build 

* clone repo

* `stack build`

* `stack exec url-shortner-exe <http port> <db host> <db port> <server id>`


# slop

```http
################################### clean up ###################################

DELETE index

################################################################################

# load 4 documents into our index

POST index/_bulk
{"index":{"_id":1}}
{"field":"open code"}
{"index":{"_id":2}}
{"field":"open source code"}
{"index":{"_id":3}}
{"field":"open source license code"}
{"index":{"_id":4}}
{"field":"code open"}

# with a slop value of 0 we are looking for an exact match, not counting analysis
# doc with _id: 1 is returned

GET index/_search
{
  "query": {
    "match_phrase": {
      "field": {
        "query": "open code",
        "slop": 0
      }
    }
  }
}

# a slop value of 1 will allow for any other single term to appear between the query terms
# doc with _id: 1 and 2 is returned

GET index/_search
{
  "query": {
    "match_phrase": {
      "field": {
        "query": "open code",
        "slop": 1
      }
    }
  }
}

# a slop of 2 will as expected allow for any 2 terms to appear between our query terms, but also perhaps unexpectedly allows for the 2 terms to switch positions
# doc with _id: 1, 2, 3 and 4 is returned

GET index/_search
{
  "query": {
    "match_phrase": {
      "field": {
        "query": "open code",
        "slop": 2
      }
    }
  }
}
```

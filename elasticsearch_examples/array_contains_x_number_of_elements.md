# array contains x number of elements

```http
################################### clean up ###################################

DELETE index

################################################################################

# ingest some example documents to test with

POST index/_bulk
{"index":{}}
{"foo":1}
{"index":{}}
{"foo":[1, 2]}

# return documents where the array field called `foo` contains only 1 element

GET index/_search
{
  "query": {
    "bool": {
      "filter": [
        {
          "exists": {
            "field": "foo"
          }
        },
        {
          "script": {
            "script": "doc['foo'].length == 1"
          }
        }
      ]
    }
  }
}

# n.b. does not work with `text` fields
```

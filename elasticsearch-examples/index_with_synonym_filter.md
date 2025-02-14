# synonyms

## description

a short example to set up an index with a synonym filter

```eb
################################### clean up ###################################

DELETE /index

################################################################################

# create an index with a synonym filter

PUT /index
{
  "settings": {
    "index": {
      "analysis": {
        "analyzer": {
          "synonym": {
            "tokenizer": "standard",
            "filter": [
              "synonym"
            ]
          }
        },
        "filter": {
          "synonym": {
            "type": "synonym",
            "synonyms": [
              "synonym,metonym"
            ]
          }
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "field": {
        "type": "text",
        "analyzer": "standard",
        "search_analyzer": "synonym"
      }
    }
  }
}

# test some text to see how our analyzer will work

GET /index/_analyze
{
  "analyzer": "synonym",
  "text": ["synonym"]
}

# test a query to see which terms will actually be used in the search

GET /index/_validate/query?rewrite=true
{
  "query": {
    "match": {
      "field": {
        "query": "metonym"
      }
    }
  }
}
```

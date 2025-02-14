# `_update_by_query` multi index

## description

update documents using only the alias with `_update_by_query`

```eb
################################### clean up ###################################

DELETE /index-1
DELETE /index-2

################################################################################

# ingest some documents into different indices

PUT /index-1/_doc/1
{
  "field": "value"
}

PUT /index-2/_doc/1
{
  "field": "different value"
}

# add the same alias to both indices

POST /_aliases
{
  "actions": [
    {
      "add": {
        "index": "index-1",
        "alias": "index"
      }
    },
    {
      "add": {
        "index": "index-2",
        "alias": "index"
      }
    }
  ]
}

GET /index/_search

# `_update_by_query` to change the value for both docs with `_id: 1`

POST /index/_update_by_query
{
  "query": {
    "term": {
      "_id": {
        "value": "1"
      }
    }
  },
  "script": {
    "source": """
      ctx._source = [
        "field": params.field
      ]
    """,
    "lang": "painless",
    "params": {
      "field": "new_value"
    }
  }
}

GET /index/_search
```

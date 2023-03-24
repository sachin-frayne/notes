# update by query multi index

```http
################################### clean up ###################################

DELETE index-1
DELETE index-2

################################################################################

PUT index-1/_doc/1
{
  "field": "value",
  "count": 1
}

PUT index-2/_doc/1
{
  "field": "different value",
  "count": 1
}

POST _aliases
{
  "actions": [
    {
      "add": {
        "index": "index-1",
        "alias": "index"
      }
    }
  ]
}

POST _aliases
{
  "actions": [
    {
      "add": {
        "index": "index-2",
        "alias": "index"
      }
    }
  ]
}

GET index/_search

POST index/_update_by_query
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

GET index/_search
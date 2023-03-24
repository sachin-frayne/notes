# nested aggs vs denormalised

```http
################################### clean up ###################################

DELETE index_nested
DELETE index_denormalised

################################################################################

PUT index_nested
{
  "mappings": {
    "properties": {
      "parent_id": {
        "type": "keyword"
      },
      "childSkus": {
        "type": "nested",
        "properties": {
          "price": {
            "type": "integer"
          },
          "colour": {
            "type": "keyword"
          }
        }
      }
    }
  }
}

POST index_nested/_doc
{
  "parent_id": "1234",
  "childSkus": [
    {
      "price": 1234,
      "colour": "red"
    },
    {
      "price": 321,
      "colour": "blue"
    }
  ]
}

POST index_nested/_doc
{
  "parent_id": "456",
  "childSkus": [
    {
      "price": 654,
      "colour": "grey"
    },
    {
      "price": 678,
      "colour": "orange"
    }
  ]
}

GET index_nested/_search
{
  "size": 0, 
  "aggs": {
    "NAME": {
      "terms": {
        "field": "parent_id",
        "size": 10
      },
      "aggs": {
        "avg_price": {
          "nested": {
            "path": "childSkus"
          },
          "aggs": {
            "NAME": {
              "avg": {
                "field": "childSkus.price"
              }
            }
          }
        }
      }
    }
  }
}

PUT index_denormalised
{
  "mappings": {
    "properties": {
      "parent_id": {
        "type": "keyword"
      },
      "childSku": {
        "properties": {
          "price": {
            "type": "integer"
          },
          "colour": {
            "type": "keyword"
          }
        }
      }
    }
  }
}

POST index_denormalised/_doc
{
  "parent_id": "1234",
  "childSku": {
    "price": 1234,
    "colour": "red"
  }
}

POST index_denormalised/_doc
{
  "parent_id": "1234",
  "childSku": {
    "price": 321,
    "colour": "blue"
  }
}

POST index_denormalised/_doc
{
  "parent_id": "456",
  "childSku": {
    "price": 654,
    "colour": "grey"
  }
}

POST index_denormalised/_doc
{
  "parent_id": "456",
  "childSku": {
    "price": 678,
    "colour": "orange"
  }
}

GET index_denormalised/_search
{
  "size": 0,
  "aggs": {
    "NAME": {
      "terms": {
        "field": "parent_id",
        "size": 10
      },
      "aggs": {
        "NAME": {
          "avg": {
            "field": "childSku.price"
          }
        }
      }
    }
  }
}
```

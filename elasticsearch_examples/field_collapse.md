# field collapse

```http
################################### clean up ###################################

DELETE index-000001
DELETE index-000002
DELETE _ingest/pipeline/ingest_timestamp

################################################################################

# create a pipeline that will add a timestamp to our data

PUT _ingest/pipeline/ingest_timestamp
{
  "processors": [
    {
      "set": {
        "field": "@timestamp",
        "value": "{{_ingest.timestamp}}"
      }
    }
  ]
}

# create 2 mappings 1 for `index-000001` and 1 for `index-000002`, they will have the same settings

PUT index-000001
{
  "aliases": {
    "index": {}
  }, 
  "settings": {
    "index": {
      "sort.field": "@timestamp",
      "sort.order": "desc"
    }
  },
  "mappings": {
    "properties": {
      "@timestamp": {
        "type": "date"
      },
      "field": {
        "type": "text"
      },
      "search_field": {
        "type": "text"
      },
      "collapse_field": {
        "type": "long"
      }
    }
  }
}

PUT index-000002
{
  "aliases": {
    "index": {}
  }, 
  "settings": {
    "index": {
      "sort.field": "@timestamp",
      "sort.order": "desc"
    }
  },
  "mappings": {
    "properties": {
      "@timestamp": {
        "type": "date"
      },
      "field": {
        "type": "text"
      },
      "search_field": {
        "type": "text"
      },
      "collapse_field": {
        "type": "long"
      }
    }
  }
}

# create the document in `index-000001`

POST index-000001/_doc?pipeline=ingest_timestamp
{
  "collapse_field": 1234,
  "field": "value",
  "search_field": "my awesome stuff"
}

# wait a little while and then index the update document to `index-000002`

POST index-000002/_doc?pipeline=ingest_timestamp
{
  "collapse_field": 1234,
  "field": "updated_value",
  "search_field": "my awesome stuff"
}

# test search to see the update value only

GET index*/_search
{
  "query": {
    "match": {
      "search_field": "my awesome stuff"
    }
  },
  "collapse": {
    "field": "collapse_field"         
  },
  "sort": [
    {
      "@timestamp": { 
        "order": "desc"
      }
    }
  ],
  "from": 0                    
}
```
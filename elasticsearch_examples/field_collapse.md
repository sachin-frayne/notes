PUT index-000001
{
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

PUT index-000001/_doc/1
{
  "collapse_field": 1234,
  "field": "value",
  "@timestamp": "2023-02-02T10:17:09Z",
  "search_field": "my awesome stuff"
}

PUT index-000002/_doc/1
{
  "collapse_field": 1234,
  "field": "updated value",
  "@timestamp": "2023-02-02T11:17:09Z",
  "search_field": "my awesome stuff"
}

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
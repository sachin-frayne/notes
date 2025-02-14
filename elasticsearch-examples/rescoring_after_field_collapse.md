# rescoring after field collapse

## description

workaround to rescore our documents after we have used field collapse

```eb
################################### clean up ###################################

DELETE /index

################################################################################

# create index mapping that satisfies collapse field requirments

PUT /index
{
  "mappings": {
    "properties": {
      "@timestamp": {
        "type": "date"
      },
      "collapse_field": {
        "type": "keyword"
      },
      "field": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword",
            "ignore_above": 256
          }
        }
      }
    }
  }
}

# index a document

PUT /index/_doc/1
{
  "field": "value",
  "@timestamp": "2023-03-30T15:15:53Z",
  "collapse_field": "collapse_value"
}

# search for the document and observe the rescore
## note `_score` is not actually needed in the sort object

GET /index/_search
{
  "query": {
    "match": {
      "field": "value"
    }
  },
  "sort": [
		{ "_score": "desc" },
    {
      "_script": {
        "type": "number",
        "order": "desc",
        "script": {
          "lang": "painless",
          "source": "return 1 + _score"
        }
      }
    }
  ],
	"collapse": {
		"field": "collapse_field"
	}
}
```
# average time delta between events

```http
################################### clean up ###################################

DELETE index
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

# run the following commands a few times several seconds apart

POST index/_doc?pipeline=ingest_timestamp
{
  "foo":"bar"
}

# calculate the average time delta between events in a certain bucket interval
## this exact request will look over the last hour splitting it into minute buckets

GET index/_search
{
  "size": 0,
  "query": {
    "bool": {
      "filter": [
        {
          "range": {
            "@timestamp": {
              "gte": "now/h-1h",
              "lte": "now/h"
            }
          }
        }
      ]
    }
  },
  "aggs": {
    "dates": {
      "date_histogram": {
        "field": "@timestamp",
        "calendar_interval": "minute"
      },
      "aggs": {
        "stats": {
          "stats": {
            "field": "@timestamp"
          }
        },
        "average_delta_seconds": {
          "bucket_script": {
            "buckets_path": {
              "count": "stats.count",
              "max": "stats.max",
              "min": "stats.min"
            },
            "script": "(params.max - params.min)/(params.count - 1)/1000"
          }
        }
      }
    }
  }
}
```

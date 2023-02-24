# average delta

```bash
# calculate the average delta between documents ingested into your index
## this exact request will look over the last hour splitting it into minute buckets

GET <index>/_search
{
  "size": 1,
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

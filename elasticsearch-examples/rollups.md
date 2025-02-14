# data rollups

## description

a short example to set up a rollup job

```eb
################################### clean up ###################################

DELETE /_ingest/pipeline/ingest_timestamp
DELETE /_rollup/job/rollup_job
DELETE /index
DELETE /rolled_index

################################################################################

# create a pipeline that will add a timestamp to our data

PUT /_ingest/pipeline/ingest_timestamp
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

# define a mapping for our data to make sure our keyword field has the correct 
# type

PUT /index
{
  "mappings": {
    "properties": {
      "@timestamp": {
        "type": "date"
      },
      "keyword": {
        "type": "keyword"
      },
      "number": {
        "type": "long"
      }
    }
  }
}

# index some documents into our data, run this request a few times several 
# seconds apart

POST /index/_bulk?pipeline=ingest_timestamp
{"index":{}}
{"keyword":"off", "number": 0}
{"index":{}}
{"keyword":"on", "number": 1}

# create the rollup job

PUT /_rollup/job/rollup_job
{
  "index_pattern": "index",
  "rollup_index": "rolled_index",
  "cron": "* * * * * ?",
  "page_size": 1000,
  "groups": {
    "date_histogram": {
      "field": "@timestamp",
      "fixed_interval": "1ms"
    },
    "terms": {
      "fields": [
        "keyword"
      ]
    }
  },
  "metrics": [
    {
      "field": "number",
      "metrics": [
        "avg"
      ]
    }
  ]
}

# start the roll job

POST /_rollup/job/rollup_job/_start

# run an aggregation in the original index

GET /index/_search
{
  "size": 0,
  "aggs": {
    "date_histogram_agg": {
      "date_histogram": {
        "field": "@timestamp",
        "fixed_interval": "1ms",
        "min_doc_count": 1
      },
      "aggs": {
        "avg_agg": {
          "avg": {
            "field": "number"
          }
        }
      }
    },
    "terms_agg": {
      "terms": {
        "field": "keyword"
      }
    }
  }
}

# run the same aggregation to the rolled_index, against the `_rollup_search` 
# API the results will be the same

GET /rolled_index/_rollup_search
{
  "size": 0,
  "aggs": {
    "date_histogram_agg": {
      "date_histogram": {
        "field": "@timestamp",
        "fixed_interval": "1ms",
        "min_doc_count": 1
      },
      "aggs": {
        "avg_agg": {
          "avg": {
            "field": "number"
          }
        }
      }
    },
    "terms_agg": {
      "terms": {
        "field": "keyword"
      }
    }
  }
}
```

# datastreams

```bash
################################### clean up ###################################

DELETE _data_stream/data-stream
DELETE _ilm/policy/data-stream-policy
DELETE _index_template/data-stream-template
DELETE _ingest/pipeline/ingest_timestamp
PUT _cluster/settings
{"transient":{"indices.lifecycle.poll_interval":null}}

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

# create an ilm policy

PUT _ilm/policy/data-stream-policy
{
  "policy": {
    "phases": {
      "hot": {
        "actions": {
          "rollover": {
            "max_docs": 1
          }
        }
      },
      "delete": {
        "min_age": "10m",
        "actions": {
          "delete": {}
        }
      }
    }
  }
}

# create the data stream template

PUT _index_template/data-stream-template
{
  "index_patterns": [
    "data-stream"
  ],
  "data_stream": {},
  "priority": 200,
  "template": {
    "settings": {
      "index.lifecycle.name": "data-stream-policy"
    }
  }
}

# ingest a document to initialise the data stream

POST data-stream/_doc?pipeline=ingest_timestamp
{
  "foo":"bar"
}

# use the data-stream as if it were an index for append and search only, no updates or deletes

GET data-stream/_search

# see the backing indices for our data stream, .ds-data-stream-*

GET _cat/indices/.ds-data-stream-*?v&h=index,docs.count

# force the data stream to rollover to see the new backing index getting created

POST data-stream/_rollover
```

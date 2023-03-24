# datastreams

```http
################################### clean up ###################################

DELETE _data_stream/datastream
DELETE _ilm/policy/datastream-policy
DELETE _index_template/datastream-template
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

PUT _ilm/policy/datastream-policy
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

PUT _index_template/datastream-template
{
  "index_patterns": [
    "datastream"
  ],
  "data_stream": {},
  "template": {
    "settings": {
      "index.lifecycle.name": "datastream-policy"
    }
  }
}

# ingest a document to initialise the data stream

POST datastream/_doc?pipeline=ingest_timestamp
{
  "foo":"bar"
}

# use the datastream as if it were an index for append and search only, no updates or deletes

GET datastream/_search

# see the backing indices for our data stream, .ds-datastream-*

GET _cat/indices/.ds-datastream-*?v&h=index,docs.count

# force the data stream to rollover to see the new backing index getting created

POST datastream/_rollover
```

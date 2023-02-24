# array contains x number of elements

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



POST data-stream/_doc?pipeline=ingest_timestamp-
{
  "foo":"bar"
}

# return documents where the array field called `foo` contains only 1 element

GET <index>/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "script": {
            "script": "doc['foo'].length == 1"
          }
        }
      ]
    }
  }
}
```

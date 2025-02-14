# index lifecycle management

## description

a short example to set up index lifecycle management

```eb
################################### clean up ###################################

DELETE /index-000001
DELETE /_ilm/policy/lifecycle-template
DELETE /_ingest/pipeline/ingest_timestamp
DELETE /_index_template/data-stream-template
PUT /_cluster/settings
{"transient":{"indices.lifecycle.poll_interval":null}}

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

# create an ilm policy

PUT /_ilm/policy/lifecycle-policy
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

# create the index template

PUT /_index_template/lifecycle-template
{
  "index_patterns": [
    "index-*"
  ],
  "template": {
    "settings": {
      "index.lifecycle.name": "lifecycle-policy",
      "index.lifecycle.rollover_alias": "alias"
    }
  }
}

# bootstrap the initial ilm indexs

PUT /index-000001
{
  "aliases": {
    "alias":{
      "is_write_index": true
    }
  }
}

# ingest a document into the index through the alias

POST /alias/_doc?pipeline=ingest_timestamp
{
  "foo":"bar"
}

# use the alias as if it were an index for append and search only, 
# no updates or deletes

GET /alias/_search

# see the backing indices for our alias, index-*

GET /_cat/indices/index-*?v&h=index,docs.count

# force the alias to rollover to see the new backing index getting created

POST /alias/_rollover
```

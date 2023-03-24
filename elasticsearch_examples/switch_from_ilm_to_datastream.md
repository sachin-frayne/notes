# switch from ilm to datastream with no downtime

```http
################################### clean up ###################################

DELETE index-name-000001
DELETE _ilm/policy/index_lifecycle_policy
DELETE _ilm/policy/datastream_policy
DELETE _data_stream/index-name-datastream
DELETE _index_template/index
DELETE _index_template/datastream
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

# create ilm policy

PUT _ilm/policy/index_lifecycle_policy
{
  "policy": {
    "phases": {
      "hot": {
        "actions": {
          "rollover": {
            "max_primary_shard_size": "30GB" 
          }
        }
      }
    }
  }
}

# create ilm index template

PUT _index_template/index
{
  "index_patterns": ["index-name-*"], 
  "template": {
    "settings": {
      "number_of_replicas": 0,
      "index.lifecycle.name": "index-name", 
      "index.lifecycle.rollover_alias": "index_policy" 
    }
  }
}

# bootstrap the ilm index

PUT index-name-000001
{
  "aliases": {
    "index-name":{
      "is_write_index": true 
    }
  }
}

# insert a document

POST index-name/_doc?pipeline=ingest_timestamp
{
  "foo": "bar"
}

# create datastream policy

PUT _ilm/policy/datastream_policy
{
  "policy": {
    "phases": {
      "hot": {
        "actions": {
          "rollover": {
            "max_primary_shard_size": "30GB" 
          }
        }
      }
    }
  }
}

# create datastream index template

PUT _index_template/datastream
{
  "index_patterns": ["index-name-datastream*"],
  "data_stream": { },
  "priority": 500, 
  "template": {
    "settings": {
      "number_of_replicas": 0,
      "index.lifecycle.name": "datastream_policy"
    }
  }
}

# create the datastream

PUT _data_stream/index-name-datastream

# ingest a document into the datastream

POST index-name-datastream/_doc?pipeline=ingest_timestamp
{
  "foo": "baz"
}

# create a new alias that points to the datastream
# the alias will also filter out documents with `"skip": true`

POST _aliases
{
  "actions": [
    {
      "add": {
        "indices": "index-name-datastream",
        "alias": "index-name-alias",
        "filter": {
          "query_string": {
            "query": "NOT true",
            "default_field": "skip"
          }
        }
      }
    }
  ]
}

# reindex all the old docs into the data stream with field `"skip" = true`

POST _reindex?wait_for_completion=false
{
  "source": {
    "index": "index-name"
  },
  "dest": {
    "index": "index-name-datastream",
    "op_type": "create"
  },
  "script": {
    "source": "ctx._source.skip = true"
  }
}

# test to see only one copy of all the docs

GET index-name*/_search

# once all docs are reindexed we can delete old indices
# and remove the alias filter in one atomic operation

POST _aliases
{
  "actions": [
    {
      "remove": {
        "index": "index-name-datastream",
        "alias": "index-name-alias"
      }
    },
    {
      "add": {
        "indices": "index-name-datastream",
        "alias": "index-name-alias"
      }
    },
    {
      "remove_index": {
        "index": "index-name-000001"
      }
    }
  ]
}

# test again to see only one copy of all the docs

GET index-name*/_search
```

# switch from ilm to datastream with no downtime

```bash
################################### clean up ###################################

DELETE index

################################################################################

PUT _ilm/policy/index_policy
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

PUT _index_template/my_template
{
  "index_patterns": ["index_name-*"], 
  "template": {
    "settings": {
      "number_of_replicas": 0,
      "index.lifecycle.name": "index_name", 
      "index.lifecycle.rollover_alias": "index_policy" 
    }
  }
}

PUT index_name-000001
{
  "aliases": {
    "index_name":{
      "is_write_index": true 
    }
  }
}

POST index_name/_doc
{
  "@timestamp": "2009-05-06T16:21:15.000Z",
  "message": "value"
}

# Datastream

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

PUT _index_template/index_name_datastream
{
  "index_patterns": ["index_name_datastream*"],
  "data_stream": { },
  "priority": 500, 
  "template": {
    "settings": {
      "number_of_replicas": 0,
      "index.lifecycle.name": "datastream_policy"
    }
  }
}

PUT _data_stream/index_name_datastream

POST index_name_datastream/_doc
{
  "@timestamp": "2009-05-06T16:21:15.000Z",
  "message": "different value"
}

POST _aliases
{
  "actions": [
    {
      "add": {
        "indices": "index_name_datastream",
        "alias": "index_name_alias",
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

POST _reindex?wait_for_completion=false
{
  "source": {
    "index": "index_name"
  },
  "dest": {
    "index": "index_name_datastream",
    "op_type": "create"
  },
  "script": {
    "source": "ctx._source.skip = true"
  }
}

GET index_name*/_search
```

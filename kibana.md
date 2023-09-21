# kibana

## clean all objects in Kibana except for config

```eb
POST .kibana/_delete_by_query
{
  "query": {
    "bool": {
      "must_not": [
        {
          "term": {
            "type": {
              "value": "space"
            }
          }
        },
        {
          "term": {
            "type": {
              "value": "config"
            }
          }
        },
        {
          "term": {
            "type": {
              "value": "config-global"
            }
          }
        }
      ]
    }
  }
}
```

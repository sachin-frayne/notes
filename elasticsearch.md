# elasticsearch

## check if node is part of a cluster

```bash
#!/usr/bin/env bash

set -euo pipefail

CLUSTER_HEALTH=$(curl -k -u "username:password" "ES_NODE_URL/_cluster/health?pretty")

NUMBER_OF_NODES=$(echo ${CLUSTER_HEALTH} | jq -r '.number_of_nodes')

if [[ $NUMBER_OF_NODES != null && $NUMBER_OF_NODES > 1 ]]
then
  exit 0
else
  exit 6
fi
```

## cluster settings

### defaults

```eb
GET _cluster/settings?include_defaults
```

### flat settings

```eb
GET _cluster/settings?flat_settings
```

## read_only_allow_delete

### default

```eb
PUT _settings
{
  "index": {
    "blocks": {
      "read_only_allow_delete": null
    }
  }
}
```

## fields

### get all the field names and their type information

```eb
GET _sql?format=txt
{
  "query": "SHOW COLUMNS IN <INDEX_NAME>"
}
```

## recovery

```eb
GET _cat/recovery?v&h=i,s,t,ty,st,source_node,target_node,f,fp,b,bp,translog_ops_percent&s=ty:desc,index,bp:desc&active_only
```

### adjust recovery speed

```eb
PUT _cluster/settings
{
  "transient": {
    "cluster.routing.allocation.node_concurrent_recoveries": 2,
    "indices.recovery.max_bytes_per_sec": "40mb",
    "cluster.routing.allocation.node_initial_primaries_recoveries": 4
  }
}
```

## snapshots

### get snapshots with start times, end times, ids, failed

```eb
GET _snapshot/found-snapshots/_all?filter_path=snapshots.start_time,snapshots.end_time,snapshots.snapshot,snapshots.shards.failed
```

## index versions list

```eb
GET _settings?filter_path=*.*.*.version.created_string&human
```

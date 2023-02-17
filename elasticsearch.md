# elasticsearch

## cluster settings

### defaults

```bash
GET _cluster/settings?include_defaults
```

### flat settings

```bash
GET _cluster/settings?flat_settings
```

## read_only_allow_delete

### default

```bash
PUT _settings
{
  "index": {
    "blocks": {
      "read_only_allow_delete": null
    }
  }
}
```

## recovery

```bash
GET _cat/recovery?v&h=i,s,t,ty,st,source_node,target_node,f,fp,b,bp,translog_ops_percent&s=ty:desc,index,bp:desc&active_only
```

### adjust recovery speed

```bash
PUT _cluster/settings
{
  "transient": {
    "cluster.routing.allocation.node_concurrent_recoveries": 2,
    "indices.recovery.max_bytes_per_sec": "40mb"
  }
}
```

## snapshots

### get snapshots with start times, end times, ids, failed

```bash
GET _snapshot/found-snapshots/_all?filter_path=snapshots.start_time,snapshots.end_time,snapshots.snapshot,snapshots.shards.failed
```

## index versions list

```bash
GET _settings?filter_path=*.*.*.version.created_string&human
```

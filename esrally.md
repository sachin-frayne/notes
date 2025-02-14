# esrally

Quickstart guide to using ES Rally

## docker

```bash
docker run -v /path/to/.rally:/rally/.rally/ elastic/rally esrally list tracks

mkdir -p /path/to/.rally/benchmarks/tracks/custom/track_name

tee /path/to/.rally/benchmarks/tracks/custom/track_name/track.json <<- 'EOF'
{
  "version": 2,
  "description": "<description>",
  "indices": [
    {
      "name": "<index_name>"
    }
  ],
  "schedule": [
    {
      "operation": {
        "name": "<operation_name>",
        "operation-type": "search",
        "body": {
          "query": {
            "match_all": {
            }
          }
        }
      },
      "clients": 8,
      "warmup-iterations": 1000,
      "iterations": 1000,
      "target-throughput": 100
    }
  ]
}
EOF

tee /path/to/.rally/benchmarks/tracks/custom/track_name/auth.json <<- 'EOF'
{
  "default": {
    "use_ssl": true,
    "basic_auth_user": "<elasticsearch_username>",
    "basic_auth_password": "<elasticsearch_password>"
  }
}
EOF

tee /path/to/.rally/benchmarks/tracks/custom/track_name/hosts.json <<- 'EOF'
{
  "default": [
    {"host": "<host>", "port": <port>}
  ]
}
EOF

docker run -v /path/to/.rally:/rally/.rally/ --platform linux/amd64 elastic/rally esrally race -track-path=/rally/.rally/benchmarks/tracks/custom/track_name --pipeline=benchmark-only --target-hosts="/rally/.rally/benchmarks/tracks/custom/track_name/hosts.json" --client-options="/rally/.rally/benchmarks/tracks/custom/track_name/auth.json"
```

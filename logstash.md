# logstash

## unit testing logstash

```conf
input {
  exec {
    command => 'echo {"message":"hello world!"}'        
    interval => 30
    codec => json
  }
}

filter {
}

output {
  stdout { codec => rubydebug }
}
```

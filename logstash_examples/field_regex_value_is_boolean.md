# find field with name regex and if field is boolean remove it

```ruby
input {
  exec {
    command => 'echo \{\"fq234fa-af43f-fa34d-j7ny-n78j7y\":false\,\"fq234fb-bf43f-fb34d-j7ny-n78j7y\":true\,\"real_field\":\"real value\"\,\"real_bool\":true\}'        
    interval => 30
    codec => json
  }
}

filter {
  ruby {
    code => "
      event.to_hash.keys.each { |field|
        if field.match(/[a-zA-Z0-9]+-[a-zA-Z0-9]+-[a-zA-Z0-9]+-[a-zA-Z0-9]+-[a-zA-Z0-9]+/)
          value = event.get(field)
          if !!value == value
            event.remove(field)
          end
        end
      }
    "
  }
}

output {
  stdout { codec => rubydebug }
}
```

# jq

## convert json object with multiple nested objects to array of objects

cat file.json | jq 'to_entries[]


| select (.value.settings.index.routing.allocation.include._tier_preference=="data_hot" and .value.settings.index.routing.allocation.require.data=="warm") | .key' -r

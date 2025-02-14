# text vs keyword

## description

there have been many blogs on `text` vs `keyword` so in this example I will just go through use cases instead

## filter fields

with the main example being an ID

```http
################################### clean up ###################################

DELETE index

################################################################################

# when we want to store IDs in Elasticsearch we should always choose the 
# keyword field type

PUT /index
{
  "mappings": {
    "properties": {
      "id_field": {
        "type": "keyword"
      }
    }
  }
}

PUT /index/_doc/1
{
  "id_field": "AR435654"
}

# now when we query on the field we get back our document as we expect

GET /index/_search
{
  "query": {
    "match": {
      "id_field": "AR435654"
    }
  }
}

# there are improvements that can be made, firstly we are generating a score
# this is not neccessary, the filed either matches or is does not, let's use a
# filter, which is nested inside a bool

GET /index/_search
{
  "query": {
    "bool": {
      "filter": [
        {
          "match": {
            "id_field": "AR435654"
          }
        }
      ]
    }
  }
}

# now lets turn on profile and check if there are some more improvements

GET /index/_search
{
  "profile": true, 
  "query": {
    "bool": {
      "filter": [
        {
          "match": {
            "id_field": "AR435654"
          }
        }
      ]
    }
  }
}

# from this we get the following telling us to switch to term query
# ...
# "type": "TermQuery",
# "description": "id_field:AR435654",
# ...

GET /index/_search
{
  "profile": true, 
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "id_field": "AR435654"
          }
        }
      ]
    }
  }
}

# usually there is no desire to lowercase IDs, but if this is the case,
# Elasticsearch has [normalisers](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-normalizers.html)
# to try this we need to re-create the index

DELETE /index

PUT /index
{
  "settings": {
    "analysis": {
      "normalizer": {
        "lowercase_normalizer": {
          "type": "custom",
          "filter": ["lowercase"]
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "id_field": {
        "type": "keyword",
        "normalizer": "lowercase_normalizer"
      }
    }
  }
}

PUT /index/_doc/1
{
  "id_field": "AR435654"
}

# now we can filter for the IDs with lowercase letters, a similar thing can be 
# done to uppercase everything

GET /index/_search
{
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "id_field": "ar435654"
          }
        }
      ]
    }
  }
}
```

very similar logic can be applied to almost every other string field, for most of them we would probably filter rather than search, I will get onto searching in the next section, but for many of them there are also [speciliased data types](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html) such as, but not limited to

* [dates](https://www.elastic.co/guide/en/elasticsearch/reference/current/date.html)
* [geo_point](https://www.elastic.co/guide/en/elasticsearch/reference/current/geo-point.html)
* [ip addresses](https://www.elastic.co/guide/en/elasticsearch/reference/current/ip.html)
* [version](https://www.elastic.co/guide/en/elasticsearch/reference/current/version.html)

these are important, since they enable some specific functions for those field types, such as date ranges, ip subnets, version ranges, (such as finding software released between 2 versions) and finally geo points to actually be placed on a map, if you don't need any of that, storing them as keyword for filtering is always a good option

## full text search fields

this is the case anytime we need to find terms inside a body of text, this can become extremely complicated so we will focus on simple examples

```https

```


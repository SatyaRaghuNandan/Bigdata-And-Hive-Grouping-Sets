# elastic 

## 建立索引
not_analyzed 不进行分词

## 查询
term是代表完全匹配，也就是精确查询，搜索前不会再对搜索词进行分词

match查询会先对搜索词进行分词,分词完毕后再逐个对分词结果进行匹配，因此相比于term的精确搜索，match是分词匹配搜索

对于match搜索，可以按照分词后的分词集合的or或者and进行匹配，默认为or
must
should



"range" : {
              "d" : {
                "from" : "2017-01-17",
                "to" : "2017-01-18",
                "include_lower" : true,
                "include_upper" : true
              }
            }


{
            "range" : {
              "d" : {
                "from" : "2017-01-17",
                "to" : null,
                "include_lower" : true,
                "include_upper" : true
              }
            }
          }, {
            "range" : {
              "d" : {
                "from" : null,
                "to" : "2017-01-18",
                "include_lower" : true,
                "include_upper" : true
              }
            }
          } 

          

http://osg.ops.ctripcorp.com/api/esapi/vacation.list.trace.kwd-2016.07.26/_search

{
    "access_token": "2dde45eacf8132d9c17671d485d963fa",
    "request_body": {
         "size":1        
    }
} 


{
  "query": {
    "bool" : {
      "must" : {
        "term" : { "user" : "kimchy" }
      },
      "filter": {
        "term" : { "tag" : "tech" }
      },
      "must_not" : {
        "range" : {
          "age" : { "gte" : 10, "lte" : 20 }
        }
      },
      "should" : [
        { "term" : { "tag" : "wow" } },
        { "term" : { "tag" : "elasticsearch" } }
      ],
      "minimum_should_match" : 1,
      "boost" : 1.0
    }
  }
}




{
    "access_token": "2dde45eacf8132d9c17671d485d963fa",
    "request_body": {
          "query": { "match": { "pageid": "105210"} } 
          ,"size":1     
    }
} 


{
    "access_token": "2dde45eacf8132d9c17671d485d963fa",
    "request_body": {
          "query": {
            "bool": {
              "must": [
                { "match": { "pageid": "105210" } },
                { "match": { "salecityid": 1 } }
              ]
            }
          }
          ,"size":2     
    }
} 


must == and
should == or
must_not == not and not




"query": {	
    "filtered": {
      "query": {
        "bool": {
          "should": [
            {
              "query_string": {
                "query": "*",
                "lowercase_expanded_terms": false
              }
            }
          ]
        }
      },
      "filter": {
        "bool": {
          "must": [
            {
              "range": {
                "@timestamp": {
                  "from": 1469435022406,
                  "to": 1469607822406
                }
              }
            },
            {
              "terms": {
                "kwd": [
                  "周边"
                ]
              }
            }
          ]
        }
      }
    }
  },
  "aggs": {
    "terms": {
      "terms": {
        "field": "sourcetype",
        "size": 10,
        "order": [
          {
            "subaggs.value": "desc"
          }
        ]
      },
      "aggs": {
        "subaggs": {
          "cardinality": {
            "field": "vid"
          }
        }
      }
    }
  },
  "size": 0



"query" : {
    "from" : 0, "size" : 10,
    "sort" : [
        { "post_date" : {"order" : "asc"}},
        "user",
        { "name" : "desc" },
        { "age" : "desc" },
        "_score"
    ],
    "_source": {
        "includes": [ "obj1.*", "obj2.*" ],
        "excludes": [ "*.description" ]
    },
    "stored_fields" : ["user", "postDate"],
    "term" : { "user" : "kimchy" }
}


"query": {
    "bool": {
      "filter": [
        { "term": { "color": "red"   }},
        { "term": { "brand": "gucci" }}
      ]
    }
  }


  {
  "query": {
    "bool": {
      "filter": {
        "term": { "brand": "gucci" } 
      }
    }
  },
  "aggs": {
    "colors": {
      "terms": { "field": "color" } 
    },
    "color_red": {
      "filter": {
        "term": { "color": "red" } 
      },
      "aggs": {
        "models": {
          "terms": { "field": "model" } 
        }
      }
    }
  },
  "post_filter": { 
    "term": { "color": "red" }
  }
}


{"aggs":{"terms":{"terms":{"field":"sourcetype"},"aggs":{"subaggs":{"cardinality":{"field":"vid"}}}}},"size": 0}





{
    "aggs" : {
        "avg_grade" : { "avg" : { "field" : "grade" } }
    }
}

{
    "aggs" : {
        "author_count" : { "cardinality" : { "field" : "author" } }
    }
}

{
    "aggs" : {
        "grades_stats" : { "extended_stats" : { "field" : "grade" } }
    }
}

{
    "aggs" : {
        "max_price" : { "max" : { "field" : "price" } }
    }
}

{
    "aggs" : {
        "grades_count" : { "value_count" : { "field" : "grade" } }
    }
}

{
    "aggs" : {
        "genres" : { "terms" : { "field" : "genre" } }
    }
}


{
    "aggs" : {
        "xxxx" : { "terms" : { "field" : "xxx","size": 10 } }
    }
}

{
    "aggs" : {
        "xxxx" : { "terms" : { "field" : "xxx","size": 10 },"aggs":{...} }
    }
}

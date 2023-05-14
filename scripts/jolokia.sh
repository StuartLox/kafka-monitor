#curl -X POST -H "Content-Type: application/json" -d '{
#  "type": "read",
#  "mbean": "java.lang:name=*,type=GarbageCollector",
#  "attribute": ["CollectionCount", "CollectionTime", "LastGcInfo"],
#  "config": {
#    "tagKeys": ["name"]
#  }
#}' http://localhost:8778/jolokia/read | jq


 curl -X POST -H "Content-Type: application/json" -d '{
  "type": "read",
  "mbean": "kmf.services:name=*,type=produce-service",
  "attribute": ["records-produced-total", "records-produced-rate"]
}' http://localhost:8778/jolokia/read | jq
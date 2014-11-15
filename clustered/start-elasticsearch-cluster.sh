#!/bin/bash

es_home=elasticsearch-1.4.0

# min and max JVM heap size are set to this value
export ES_HEAP_SIZE=1g

# Give the cluster a unique name to avoid auto-discovery collisions with other elasticsearch nodes on the same network
es_config="-Des.cluster.name=1devday"

# Default indexes to having 2 shards and one replica for each shard.
es_config="${es_config} -Des.index.number_of_shards=2 -Des.index.number_of_replicas=1"

# Move the elasticsearch data and log directories outside of the elasticsearch install to make upgrading easier.
es_config="${es_config} -Des.path.data=var/data/elasticsearch -Des.path.logs=var/logs/elasticsearch"

# Enable cross-origin requests from Kibana
es_config="${es_config} -Des.http.cors.enabled=true -Des.http.cors.allowed-origin=http://localhost:9080"

# Have elasticsearch print out the maximum number of open file descriptors it is allowed when starting up.
es_config="${es_config} -Des.max-open-files" 

for node in node1 node2; do
  pid=$(ps -o pid,command -e | grep elasticsearch | grep "bin/java" | grep "${node}" | awk '{printf "%d\n", $1}')
  if [ -n "${pid}" ]; then
    echo "Elasticsearch ${node} already running as ${pid}."
    exit 1
  fi

  ${es_home}/bin/elasticsearch ${es_config} -Des.node.name=${node} -p ${es_home}/es-${node}.pid -d

  echo "Elasticsearch ${node} started."
done

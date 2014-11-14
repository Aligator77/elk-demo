#!/bin/bash
for node in node1 node2; do
  pid=$(ps -o pid,command -e | grep elasticsearch | grep "bin/java" | grep "${node}" | awk '{printf "%d\n", $1}')
  if [ -n "${pid}" ]; then
    echo "Killing elasticsearch ${node} process ${pid}."
    kill ${pid}
  else
    echo "Elasticsearch ${node} not running."
  fi
done

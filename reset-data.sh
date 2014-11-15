#!/bin/bash

pid=$(ps -o pid,command -e | grep elasticsearch | grep "bin/java" | awk '{printf "%d\n", $1}')
if [ -n "${pid}" ]; then
  echo "Elasticsearch is running as process ${pid}. Please stop it before resetting data."
  exit 1
fi

pid=$(ps -o pid,command -e | grep logstash | grep "bin/java" | awk '{printf "%d\n", $1}')
if [ -n "${pid}" ]; then
  echo "Logstash is running as process ${pid}. Please stop it before resetting data."
  exit 1
fi

pid=$(ps -o pid,command -e | grep node | grep kibana | awk '{printf "%d\n", $1}')
if [ -n "${pid}" ]; then
  echo "Kibana web server is running as process ${pid}. Please stop it before resetting data."
  exit 1
fi

for dir in var/data/elasticsearch var/data/logstash var/logs/elasticsearch var/logs/logstash var/logs/kibana var/logs/input; do
  echo "Removing data from ${dir}"
  rm -rf ${dir}
  mkdir -p ${dir}
done

./generate-logs.sh
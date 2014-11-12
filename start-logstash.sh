#!/bin/bash

pid=$(ps -o pid,command -e | grep logstash | grep "bin/java" | awk '{printf "%d\n", $1}')
if [ -n "${pid}" ]; then
  echo "Logstash is already running as process ${pid}."
  exit 1
fi

LS_HEAP_SIZE=1g
export LS_HEAP_SIZE
nohup logstash-1.4.2/bin/logstash -f conf/logstash.conf 2>&1 >> var/logs/logstash/logstash.log &
echo "Logstash started."

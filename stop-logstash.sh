#!/bin/bash
pid=$(ps -o pid,command -e | grep logstash | grep "bin/java" | awk '{printf "%d\n", $1}')
if [ -n "${pid}" ]; then
  echo "Killing logstash process ${pid}."
  kill ${pid}
else
  echo "Logstash not running."
fi

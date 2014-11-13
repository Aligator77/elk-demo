#!/bin/bash

pid=$(ps -o pid,command -e | grep node | grep kibana | awk '{printf "%d\n", $1}')
if [ -n "${pid}" ]; then
  echo "Kibana web server is already running as process ${pid}."
  exit 1
fi

nohup node kibana-server.js 2>&1 >> var/logs/kibana/kibana.log &
echo "Kibana started."

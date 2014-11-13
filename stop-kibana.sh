#!/bin/bash
pid=$(ps -o pid,command -e | grep node | grep kibana | awk '{printf "%d\n", $1}')
if [ -n "${pid}" ]; then
  echo "Killing kibana web server process ${pid}."
  kill ${pid}
else
  echo "Kibana web server not running."
fi

#!/bin/bash
pid=$(ps -o pid,command -e | grep elasticsearch | grep "bin/java" | awk '{printf "%d\n", $1}')
if [ -n "${pid}" ]; then
  echo "Killing elasticsearch process ${pid}."
  kill ${pid}
else
  echo "Elasticsearch not running."
fi

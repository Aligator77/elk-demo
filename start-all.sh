#!/bin/bash
./start-elasticsearch.sh
echo "Waiting 5 seconds for elasticsearch to start..."
sleep 5
./start-logstash.sh
./start-kibana.sh
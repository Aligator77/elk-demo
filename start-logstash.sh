#!/bin/bash
LS_HEAP_SIZE=1g
export LS_HEAP_SIZE
nohup logstash-1.4.2/bin/logstash -f conf/logstash.conf 2>&1 >> var/logs/logstash/logstash.log &

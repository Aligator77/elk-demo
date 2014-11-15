#!/bin/bash

# Generate log data to index
java -jar lib/log-gen-0.1.0-standalone.jar 100000 var/logs/input/access-server1.log.tmp
sort var/logs/input/access-server1.log.tmp > var/logs/input/access-server1.log
rm var/logs/input/access-server1.log
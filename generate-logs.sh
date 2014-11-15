#!/bin/bash

# Generate log data to index
event_count=100000
echo "Generating access log file with ${event_count} entries..."
java -jar lib/log-gen-0.2.0-standalone.jar ${event_count} var/logs/input/access-server1.log.tmp
echo "Sorting access log into chronological order..."
time sort var/logs/input/access-server1.log.tmp > var/logs/input/access-server1.log
rm var/logs/input/access-server1.log.tmp
echo "Log generation complete."
# elk-demo

Make getting from nothing to a running configuration of [Elasticsearch](http://www.elasticsearch.org/overview/elasticsearch/), [Logstash](http://logstash.net), and [Kibana](http://www.elasticsearch.org/overview/kibana/) as easy as possible.

* Downloads, installs, and configures Elasticsearch, Logstash, Kibana, and [kopf plugin](https://github.com/lmenezes/elasticsearch-kopf)
* Provides scripts for starting, stopping, and resetting data
* Generates log data to index

## Prerequisites

* JDK (1.7 or 1.8 should work)
* node.js (any relatively recent version)
* Linux or OS X (for the shell scripts that do the setup)

## Installation

* Clone project and get everything running
    $ git clone git@github.com:dgrabows/elk-demo.git
    $ ./install.sh
    $ ./start-all.sh
* Open the admin UI [http://localhost:9200/_plugin/kopf](http://localhost:9200/_plugin/kopf)
* Open Kibana [http://localhost:9080/index.html#/dashboard/file/logstash.json](http://localhost:9080/index.html#/dashboard/file/logstash.json)
* Shut things down when done
    $ ./stop-all.sh
* Clean out the data and regenerate a new set (with everything stopped)
    $ ./reset-data.sh

## License

Copyright © 2014 Dan Grabowski

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


#!/bin/bash

# Copyright 2014 Dan Grabowski
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# returns 0 if download and checksum successful
download_file() {
  url="$1"
  target_file="$2"
  checksum_algo="$3"
  expected_checksum="$4"
  
  if [ ! -f "$target_file" ]; then
    printf 'Downloading %s from %s.\n' "$target_file" "$url"
    curl -L "$url" -o "$target_file"
  else
    printf '%s already existed. Re-using file.\n' "$target_file"
  fi
  if [ -f "$target_file" ]; then
    calculated_checksum=$(openssl "$checksum_algo" < "$target_file")
    if [ "$expected_checksum" == "$calculated_checksum" ]; then
      printf 'Checksum ok.\n'
    else
      printf '! %s checksum did not match. Delete file to retry download.\n' "$checksum_algo"
      printf 'File:     %s\n' "$target_file"
      printf 'Expected: %s\n' "$expected_checksum"
      printf 'Actual:   %s\n' "$calculated_checksum"
      return 1
    fi
  else
    printf '! Unable to download %s from %s.\n' "$target_file" "$url"
    return 1
  fi
  return 0
}

ensure_dir() {
  dir="$1"
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
    printf '%s/ created.\n' "$dir"
  else
    printf '%s/ already exists.\n' "$dir"
  fi
}

install_package () {
  name="$1"
  url="$2"
  file="$3"
  cs_algo="$4"
  checksum="$5"
  
  if [ ! -d "./$name" ]; then
    download_file "$url" "$file" "$cs_algo" "$checksum"
    if [ $? -eq 0 ]; then
      printf 'Installing %s in ./%s/.\n' "$name" "$name"
      tar -xf $file -C .
    fi
  else
    printf "%s already installed in ./%s/.\n" "$name" "$name"
  fi
}

ensure_dir "downloads"
ensure_dir "var"
ensure_dir "var/logs"
ensure_dir "var/logs/elasticsearch"
ensure_dir "var/logs/logstash"
ensure_dir "var/data"
ensure_dir "var/data/elasticsearch"

install_package "elasticsearch-1.4.0" \
  "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.0.tar.gz" \
  "downloads/elasticsearch-1.4.0.tar.gz" \
  "sha1" \
  "728913722bc94dad4cb5e759a362f09dc19ed6fe"

install_package "logstash-1.4.2" \
  "https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz" \
  "downloads/logstash-1.4.2.tar.gz" \
  "sha1" \
  "d59ef579c7614c5df9bd69cfdce20ed371f728ff"

install_package "kibana-3.1.2" \
  "https://download.elasticsearch.org/kibana/kibana/kibana-3.1.2.tar.gz" \
  "downloads/kibana-3.1.2.tar.gz" \
  "sha1" \
  "a59ea4abb018a7ed22b3bc1c3bcc6944b7009dc4"

# install the kopf (https://github.com/lmenezes/elasticsearch-kopf) plugin for elasticsearch cluster administration
kopf_installed=$(./elasticsearch-1.4.0/bin/plugin -l | grep -c kopf)
if [ $kopf_installed -eq 0 ]; then
  printf 'Installing kopf Elasticsearch plugin.\n'
  ./elasticsearch-1.4.0/bin/plugin --install lmenezes/elasticsearch-kopf/1.3.8
else
  printf 'kopf Elasticsearch plugin already installed.\n'
fi
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

something_failed=false

# returns 0 if download and checksum successful
download_file() {
  url="$1"
  target_file="$2"
  checksum_algo="$3"
  expected_checksum="$4"
  
  if [ ! -f "$target_file" ]; then
    printf '+ Downloading %s from %s.\n' "$target_file" "$url"
    curl -L "$url" -o "$target_file"
  else
    printf '%s already existed. Re-using file.\n' "$target_file"
  fi
  if [ -f "$target_file" ]; then
    calculated_checksum=$(openssl "$checksum_algo" < "$target_file")
    if [ "$expected_checksum" == "$calculated_checksum" ]; then
      printf 'Checksum ok.\n'
    else
      something_failed=true
      printf '! %s checksum did not match. Delete file to retry download.\n' "$checksum_algo"
      printf 'File:     %s\n' "$target_file"
      printf 'Expected: %s\n' "$expected_checksum"
      printf 'Actual:   %s\n' "$calculated_checksum"
      return 1
    fi
  else
    something_failed=true
    printf '! Unable to download %s from %s.\n' "$target_file" "$url"
    return 1
  fi
  return 0
}

ensure_dir() {
  dir="$1"
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
    printf '+ %s created.\n' "$dir"
  else
    printf '%s already exists.\n' "$dir"
  fi
}

install_package () {
  name="$1"
  url="$2"
  file="$3"
  cs_algo="$4"
  checksum="$5"
  base_dir="$6"
  
  ensure_dir "$base_dir"
  
  if [ ! -d "$base_dir/$name" ]; then
    download_file "$url" "$file" "$cs_algo" "$checksum"
    if [ $? -eq 0 ]; then
      printf '+ Installing %s in %s/%s.\n' "$name" "$base_dir" "$name"
      tar -xf $file -C $base_dir
    fi
  else
    printf "%s already installed in %s/%s.\n" "$name" "$base_dir" "$name"
  fi
}

ensure_dir "downloads"

install_package "kibana-3.1.2" \
  "https://download.elasticsearch.org/kibana/kibana/kibana-3.1.2.tar.gz" \
  "downloads/kibana-3.1.2.tar.gz" \
  "sha1" \
  "7769da308d9ab571ab908c0896ea9737cb868dcf" \
  "kibana-3.1.2"
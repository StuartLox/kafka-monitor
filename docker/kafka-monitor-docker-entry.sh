#!/bin/bash

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


set -x

# SIGTERM-handler
trap 'pkill java; exit 130' SIGINT
trap 'pkill java; exit 143' SIGTERM

#  wait for DNS services to be available
sleep 10

bin/single-cluster-monitor.sh --topic test --broker-list kafka.confluent.svc.cluster.local:9092


wait $!
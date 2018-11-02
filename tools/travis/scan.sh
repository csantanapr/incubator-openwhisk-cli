#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

#
#  Determine default directories, etc., so we're not beholden to Travis
#  when running tests of the script during the development cycle.
#
openwhisk_cli_tag=${1:-"latest"}
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TRAVIS_BUILD_DIR="$( cd "${TRAVIS_BUILD_DIR:-$scriptdir/../..}" && pwd )"
export TRAVIS_BUILD_DIR

# For the gradle builds.
HOMEDIR="$(dirname "$TRAVIS_BUILD_DIR")"

#
#  Run scancode using the ASF Release configuration
#
UTILDIR="$( cd "${UTILDIR:-$HOMEDIR/incubator-openwhisk-utilities}" && pwd )"
export UTILDIR
cd $UTILDIR
scancode/scanCode.py --config scancode/ASF-Release.cfg $TRAVIS_BUILD_DIR

#
#  Run Golint
#
cd $TRAVIS_BUILD_DIR
./gradlew --console=plain goLint

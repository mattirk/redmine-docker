#!/bin/bash
# Copyright 2015 Jubic Oy
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# 		http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

function truncate () {
  APP_LOG="${RUBY_HOME}/app/log/production.log"
  SIZE_LIMIT=10485760
  while true; do
    CURR_SIZE=$(stat -c %s "${APP_LOG}")
    if [ $CURR_SIZE -ge $SIZE_LIMIT ]; then
      > "${APP_LOG}"
    else
      sleep 3600
    fi
  done
}

function start () {
  truncate & \
    bundle exec passenger start
}

source "${RUBY_HOME}/.rvm/scripts/rvm" \
  && pushd "${RUBY_HOME}/app" \
    && export RAILS_ENV=production \
    && bundle exec rake db:migrate \
    && bundle exec rake redmine:plugins:migrate \
    && start

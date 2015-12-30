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
set -e
source "${RUBY_HOME}/.rvm/scripts/rvm"

# Configure
cp "${RUBY_HOME}/Passengerfile.json" "${RUBY_HOME}/app/"
cp "${RUBY_HOME}/confs/additional_environment.rb" "${RUBY_HOME}/app/config/"
cp "${RUBY_HOME}/confs/configuration.yml" "${RUBY_HOME}/app/config/"
ln -sf /proc/self/fd/1 "${RUBY_HOME}/app/log/passenger.log"
rm -rf "${RUBY_HOME}/app/files"
ln -sf "${RUBY_HOME}/volume/files" "${RUBY_HOME}/app/"

# Install bundle
pushd "${RUBY_HOME}/app"
  export RAILS_ENV=production
  bundle install --without development test rmagick
  bundle exec rake generate_secret_token
popd

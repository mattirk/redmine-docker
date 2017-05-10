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

init_links () {
  mkdir -p "${RUBY_HOME}/volume/redmine/files"

  ln -sf /proc/self/fd/1 "${RUBY_HOME}/app/log/passenger.log"

  rm -rf "${RUBY_HOME}/app/files"
  ln -sf "${RUBY_HOME}/volume/redmine/files" "${RUBY_HOME}/app/"

  # configuration.yml
  REDMINE_CONFIGURATION="${RUBY_HOME}/volume/redmine/configuration.yml"
  REDMINE_CONFIGURATION_TEMPLATE="${RUBY_HOME}/app/config/configuration.yml.example"
  REDMINE_CONFIGURATION_TARGET="${RUBY_HOME}/app/config/configuration.yml"
  if [ ! -f "$REDMINE_CONFIGURATION" ]; then
    cp -f "${RUBY_HOME}/app/config/configuration.yml.example" "${REDMINE_CONFIGURATION}"
  fi
  ln -sf "${REDMINE_CONFIGURATION}" "${REDMINE_CONFIGURATION_TARGET}"

  # settings.yml
  REDMINE_SETTINGS="${RUBY_HOME}/volume/redmine/settings.yml"
  REDMINE_SETTINGS_TEMPLATE="${RUBY_HOME}/app/config/settings.yml.template"
  REDMINE_SETTINGS_TARGET="${RUBY_HOME}/app/config/settings.yml"
  if [ ! -f "$REDMINE_SETTINGS_TEMPLATE" ]; then
    cp "${REDMINE_SETTINGS_TARGET}" "${REDMINE_SETTINGS_TEMPLATE}"
  fi
  if [ ! -f "${REDMINE_SETTINGS}" ]; then
    cp -f "${REDMINE_SETTINGS_TEMPLATE}" "${REDMINE_SETTINGS}"
  fi
  rm "${REDMINE_SETTINGS_TARGET}"
  ln -sf "${REDMINE_SETTINGS}" "${REDMINE_SETTINGS_TARGET}"
}

init_conf () {
  cp "${RUBY_HOME}/Passengerfile.json" "${RUBY_HOME}/app/"
  cp "${RUBY_HOME}/confs/additional_environment.rb" "${RUBY_HOME}/app/config/"
}

init_bundle () {
  pushd "${RUBY_HOME}/app"
    export RAILS_ENV=production
    bundle install --without development test
    bundle exec rake generate_secret_token
  popd
}

function copy_custom_themes () {
  if [ -d "${RUBY_HOME}/volume/custom_themes" ]; then
    cp -rf ${RUBY_HOME}/volume/custom_themes/* ${RUBY_HOME}/app/public/themes/
  fi
}

function copy_custom_plugins () {
  if [ -d "${RUBY_HOME}/volume/custom_plugins" ]; then
    cp -rf ${RUBY_HOME}/volume/custom_plugins/* ${RUBY_HOME}/app/plugins/
  fi
}

init_conf
init_links
init_bundle
copy_custom_themes
copy_custom_plugins

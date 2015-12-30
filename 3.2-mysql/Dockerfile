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
FROM jubicoy/redmine-base
MAINTAINER Vilppu Vuorinen "vilppu.vuorinen@jubic.fi"

ENV REDMINE_VERSION 3.2.0
ENV REDMINE_PKG redmine-${REDMINE_VERSION}

# Install
RUN cd ${RUBY_HOME} \
  && curl -SLO "http://www.redmine.org/releases/${REDMINE_PKG}.tar.gz" \
  && tar -xzf "${REDMINE_PKG}.tar.gz" \
  && mv "${REDMINE_PKG}" app \
  && rm "${REDMINE_PKG}.tar.gz"

RUN cp ${RUBY_HOME}/confs/database.yml.mysql ${RUBY_HOME}/app/config/database.yml \
  && ${RUBY_HOME}/scripts/bundle.sh

USER root
RUN /usr/libexec/fix-permissions ruby "${RUBY_HOME}"
USER 1001

VOLUME ${RUBY_HOME}/volume


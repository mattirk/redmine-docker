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
FROM jubicoy/passenger:ruby-2.1
MAINTAINER Vilppu Vuorinen "vilppu.vuorinen@jubic.fi"

USER root

RUN apt-get update && apt-get install -y \
	libmagickwand-dev \
	imagemagick \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${RUBY_HOME}/scripts \
  && mkdir -p ${RUBY_HOME}/files

ADD scripts/* ${RUBY_HOME}/scripts/
ADD Passengerfile.json ${RUBY_HOME}/
ADD config/* ${RUBY_HOME}/confs/

ADD root /
RUN mkdir -p ${RUBY_HOME}/volume/redmine \
 && /usr/libexec/fix-permissions ruby "${RUBY_HOME}"

USER 1001
CMD bin/bash "${RUBY_HOME}/scripts/run.sh"

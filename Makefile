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

SHELL := /bin/bash

ifeq ($(TARGET),3.2-mysql)
	VERSION := 3.2-mysql
endif
ifdef NOCACHE
	OPTS := --no-cache
endif

IMAGE_NAME := jubicoy/redmine
BASE_IMAGE_NAME := $(IMAGE_NAME)-base

baseimage:
	pushd common \
		&& docker build -t $(BASE_IMAGE_NAME) . \
		&& popd

container: baseimage
ifndef VERSION
	$(error TARGET not set or invalid)
endif
	pushd $(VERSION) \
		&& docker build $(OPTS) -t $(IMAGE_NAME):$(VERSION) . \
		&& popd

push:
	docker push $(IMAGE_NAME):$(VERSION)

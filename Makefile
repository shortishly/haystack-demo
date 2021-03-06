#-*- mode: makefile-gmake -*-
# Copyright (c) 2012-2016 Peter Morgan <peter.james.morgan@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
PROJECT = haystack_demo
PROJECT_DESCRIPTION = Simple Microservice To Demonstrate Load Balancing
PROJECT_VERSION = 0.0.1


DEPS = \
	cowboy \
	envy \
	shelly

LOCAL_DEPS = \
	sasl

dep_envy = git https://github.com/shortishly/envy.git master
dep_shelly = git https://github.com/shortishly/shelly.git master
dep_cowboy = git https://github.com/ninenines/cowboy.git 2.0.0-pre.3

SHELL_DEPS = \
	sync

SHELL_OPTS = \
	-boot start_sasl \
	-config dev.config \
	-s $(PROJECT) \
	-s rb \
	-s sync


include erlang.mk

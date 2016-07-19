#!/bin/bash -ex
# Copyright 2016 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

export LANG=en_US.utf8

# Temporary, until we split jobs into different pieces:
WORKSPACE=`pwd`
if [[ $WORKSPACE =~ 'puppet-3' ]]; then
    export PUPPET_GEM_VERSION='~> 3'
else
    export PUPPET_GEM_VERSION='~> 4'
fi

mkdir .bundled_gems
export GEM_HOME=`pwd`/.bundled_gems
gem install bundler --no-rdoc --no-ri --verbose

# Build fake module
OS_NEW_MODULE_TEST=yes bash -x ./contrib/bootstrap.sh whazz dummy
cd puppet-whazz/puppet-modulesync-configs/modules/puppet-whazz
$GEM_HOME/bin/bundle install --retry 3

# lint tests
$GEM_HOME/bin/bundle exec rake lint

# Ruby files syntax tests
$GEM_HOME/bin/bundle exec rake validate

# Rspec tests
$GEM_HOME/bin/bundle exec rake spec

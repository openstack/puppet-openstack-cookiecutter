#!/bin/bash
#
# Author: Yanis Guenane <yguenane@redhat.com>
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

#
# This script has for objective to automate the generation of a basic puppet
# module that would be compliant with PuppetOpenstack standard.
# It handles both part the cookiecutter file generation and the modulesync
# common file synchronization
#
# Requirements:
#
#   * git (package)
#   * git-review (package or pip)
#   * cookiecutter (package or pip)
#   * modulesync (gem)
#   * digest (gem)
#   * virtualenv (package or pip when running test)
set -e

proj=$1
user=$2
testing=${OS_NEW_MODULE_TEST:+yes}
cookiecutter_url=https://git.openstack.org/openstack/puppet-openstack-cookiecutter

if [ -z "$proj" ] || [ -z "$user" ] ; then
    echo "usage: $0 project-name gerrit-user-id"
    exit 1
fi

if [ -z "${testing}" ]; then
    tmp_var="/tmp/puppet-${proj}"
else
    tmp_var="${PWD}/puppet-${proj}"
    cookiecutter_conf="${PWD}/default-config.yaml"
    virtualenv virtenv
    . virtenv/bin/activate
    # https://github.com/audreyr/cookiecutter/pull/621
    if ! grep -q poyo virtenv/lib/python2.7/site-packages/cookiecutter-*.egg-info/requires.txt; then
        # Requires gcc
        if [ -z "$(which gcc 2>/dev/null)" ]; then
            echo "GCC is required to install cookiecutter."
            exit 1
        fi
        pip install ruamel.yaml
    fi
    pip install cookiecutter==1.3.0
    cat > "${cookiecutter_conf}" <<EOF
---
default_context:
  project_name: $proj
  version: 0.0.1
  year: 2016
EOF
fi

rm -rf "${tmp_var}"
mkdir -p "${tmp_var}"/{cookiecutter,openstack}
pushd "${tmp_var}"

# Step 1: Generate the skeleton of the module
#
pushd cookiecutter
if [ -z "${testing}" ]; then
    cookiecutter "${cookiecutter_url}"
else
    # use current repo for CI, because we want to test current patch
    cookiecutter --no-input --config-file="${cookiecutter_conf}" "../.."
fi
popd

# Step 2: Retrieve the git repository of the project
#
if [ -z "${testing}" ]; then
    pushd openstack
    git clone https://review.openstack.org/openstack/puppet-$proj
    mv puppet-$proj/.git ../cookiecutter/puppet-$proj/
    popd
else
    pushd cookiecutter/puppet-$proj
    git init
    popd
fi

# Step 3: Add the cookiecutter file and make an initial commit
#
pushd cookiecutter/puppet-$proj
git add --all && git commit -am "puppet-${proj}: Initial Commit

This is the initial commit for puppet-${proj}.
It has been automatically generated using cookiecutter[1] and msync[2]
[1] https://github.com/openstack/puppet-openstack-cookiecutter
[2] https://github.com/openstack/puppet-modulesync-configs
"
popd

# Step 4: Retrieve the puppet-modulesync-configs directory and configure it for your need
#
git clone https://review.openstack.org/openstack/puppet-modulesync-configs
pushd puppet-modulesync-configs/
[ -z "${testing}" ] || ${GEM_HOME}/bin/bundle install
cat > managed_modules.yml <<EOF
---
  - puppet-$proj
EOF
cat > modulesync.yml <<EOF
---
namespace:
git_base: file://$tmp_var/cookiecutter/
branch: initial_commit
EOF

# Step 5: Run msync and amend the initial commit
#
if [ -z "${testing}" ]; then
    msync update --noop
else
    ${GEM_HOME}/bin/bundle exec msync update --noop
fi
pushd modules/puppet-$proj
md5password=`ruby -e "require 'digest/md5'; puts 'md5' + Digest::MD5.hexdigest('pw${proj}')"`
sed -i "s/md5c530c33636c58ae83ca933f39319273e/${md5password}/g" spec/classes/${proj}_db_postgresql_spec.rb
git remote add gerrit ssh://$user@review.openstack.org:29418/openstack/puppet-$proj.git
git add --all && git commit --amend -am "puppet-${proj}: Initial commit

This is the initial commit for puppet-${proj}.
It has been automatically generated using cookiecutter[1] and msync[2]

[1] https://github.com/openstack/puppet-openstack-cookiecutter
[2] https://github.com/openstack/puppet-modulesync-configs
"

echo "

-----------------------------------------------------------------------------------------------------
The new project has been successfully set up.

To submit the initial review please go to ${tmp_var}/puppet-modulesync-configs/modules/puppet-${proj}
and run git review.

Happy Hacking !
"

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
set -e

proj=$1
user=$2
testing=${OS_NEW_MODULE_TEST:+yes}
cookiecutter_url=https://opendev.org/openstack/puppet-openstack-cookiecutter

if [ -z "$proj" ] || [ -z "$user" ] ; then
    echo "usage: $0 project-name gerrit-user-id"
    exit 1
fi

check_gerrit_user() {
  if [[ -z $(git config --global user.name) ]]; then
    echo "WARNING: Git commiter name is not set, setting it locally..."
    git config --local user.name "Puppet OpenStack Cookiecutter"
  fi

  if [[ -z $(git config --global user.email) ]]; then
    echo "WARNING: Git commiter email is not set, setting it locally..."
    git config --local user.email "puppet-openstack-cookiecutter@example.com"
  fi
}

cleanup_gerrit_user() {
  if [[ -n $(git config --local user.name) || -n $(git config --local user.email) ]]; then
    echo "
WARNING: We configured a temporary user/email for the initial commit.
You will need to reset this information prior to running git review. Please
configure your name and email in the git config and update the previous
commit with your author information.

git config --global user.name "Your Name"
git config --global user.email "your@email"
cd `pwd`
git commit --amend --author='Your Name <your@email>'"

    git config --local --unset user.name
    git config --local --unset user.email
  fi
}

if [ -z "${testing}" ]; then
    tmp_var="/tmp/puppet-${proj}"
else
    tmp_var="${PWD}/puppet-${proj}"
    cookiecutter_conf="${PWD}/default-config.yaml"
    # https://github.com/audreyr/cookiecutter/pull/621
    if ! grep -q poyo /usr/lib/python2.7/site-packages/cookiecutter-*.egg-info/requires.txt; then
        # Requires gcc
        if [ -z "$(which gcc 2>/dev/null)" ]; then
            echo "GCC is required to install cookiecutter."
            exit 1
        fi
        sudo pip install ruamel.yaml
    fi
    sudo pip install cookiecutter==1.3.0
    cat > "${cookiecutter_conf}" <<EOF
---
default_context:
  project_name: $proj
  version: 0.0.1
  year: 2019
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

check_gerrit_user
git add --all && git commit -am "puppet-${proj}: Initial Commit

This is the initial commit for puppet-${proj}.
It has been automatically generated using cookiecutter[1] and msync[2]
[1] https://github.com/openstack/puppet-openstack-cookiecutter
[2] https://github.com/openstack/puppet-modulesync-configs
"
cleanup_gerrit_user
popd

# Step 4: Retrieve the puppet-modulesync-configs directory and configure it for your need
#
if [ -e /usr/zuul-env/bin/zuul-cloner ] ; then
    /usr/zuul-env/bin/zuul-cloner --cache-dir /opt/git \
        https://opendev.org x/puppet-modulesync-configs
else
    git clone https://opendev.org/x/puppet-modulesync-configs x/puppet-modulesync-configs
fi
pushd x/puppet-modulesync-configs/
#TODO(aschultz): fixme after we unstick the gate
# 0.8.x doesn't seem to work with out configs so we need to pin this but the
# this script is unhappy.
sed -i "s/'>=0.6.0'/['>=0.6.0','<0.8.0']/" Gemfile
[ -z "${testing}" ] || ${GEM_HOME}/bin/bundle install
cat > managed_modules.yml <<EOF
---
  - puppet-$proj
EOF
cat > modulesync.yml <<EOF
---
namespace: cookiecutter
git_base: file://$tmp_var/
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

check_gerrit_user

md5password=`ruby -e "require 'digest/md5'; puts 'md5' + Digest::MD5.hexdigest('pw${proj}')"`
sed -i "s/md5c530c33636c58ae83ca933f39319273e/${md5password}/g" spec/classes/${proj}_db_postgresql_spec.rb
git remote add gerrit ssh://$user@review.openstack.org:29418/openstack/puppet-$proj.git
git add --all && git commit --amend -am "puppet-${proj}: Initial commit

This is the initial commit for puppet-${proj}.
It has been automatically generated using cookiecutter[1] and msync[2]

[1] https://github.com/openstack/puppet-openstack-cookiecutter
[2] https://github.com/openstack/puppet-modulesync-configs
"

cleanup_gerrit_user

echo "

-----------------------------------------------------------------------------------------------------
The new project has been successfully set up.

To submit the initial review please go to ${tmp_var}/openstack/puppet-modulesync-configs/modules/puppet-${proj}
and run git review.

Happy Hacking !
"

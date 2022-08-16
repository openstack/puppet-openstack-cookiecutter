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
    set +e
    which pip3 2>&1
    ret=$?
    set -e
    if [ $ret -eq 0 ]; then
      pip_bin=pip3
    else
      pip_bin=pip
    fi
    sudo $pip_bin install cookiecutter==1.7.0
    cat > "${cookiecutter_conf}" <<EOF
---
default_context:
  project_name: $proj
  version: 0.0.1
  year: 2020
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
    git clone https://review.opendev.org/openstack/puppet-$proj
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
[1] https://opendev.org/openstack/puppet-openstack-cookiecutter
[2] https://opendev.org/x/puppet-modulesync-configs
"
cleanup_gerrit_user
popd

# Step 4: Retrieve the puppet-modulesync-configs directory and configure it for your need
#
if [ -d /home/zuul/src/opendev.org/x/puppet-modulesync-configs ]; then
    [ ! -d x/puppet-modulesync-configs ] && mkdir -p x/puppet-modulesync-configs
    cp -dR /home/zuul/src/opendev.org/x/puppet-modulesync-configs/. x/puppet-modulesync-configs
else
    git clone https://opendev.org/x/puppet-modulesync-configs x/puppet-modulesync-configs
fi
pushd x/puppet-modulesync-configs/

# Purge .git to make sure the git command in the subdirectory does not look up
# the git infomation at the top directory.
rm -rf .git

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

pushd modules/cookiecutter/puppet-$proj

check_gerrit_user

git remote add gerrit ssh://$user@review.opendev.org:29418/openstack/puppet-$proj.git
git add --all && git commit --amend -am "puppet-${proj}: Initial commit

This is the initial commit for puppet-${proj}.
It has been automatically generated using cookiecutter[1] and msync[2]

[1] https://opendev.org/openstack/puppet-openstack-cookiecutter
[2] https://opendev.org/x/puppet-modulesync-configs
"

cleanup_gerrit_user

echo "

-----------------------------------------------------------------------------------------------------
The new project has been successfully set up.

To submit the initial review please go to ${tmp_var}/openstack/puppet-modulesync-configs/modules/cookiecutter/puppet-${proj}
and run git review.

Happy Hacking !
"

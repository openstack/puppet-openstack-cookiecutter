#!/bin/bash -ex

export SCRIPT_DIR=$(cd `dirname $0` && pwd -P)
source $SCRIPT_DIR/functions

prepare_environment

# run litmus tests
export RSPEC_DEBUG=true
$GEM_HOME/bin/bundle exec rake litmus:acceptance:localhost

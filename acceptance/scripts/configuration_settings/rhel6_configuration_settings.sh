#!/bin/bash
script_dir=${0%/*}
acceptance_dir=$script_dir/../../

cd $acceptance_dir

export pe_dist_dir=https://artifactory.delivery.puppetlabs.net/artifactory/generic_enterprise__local/archives/releases/3.7.1/

export BEAKER_TESTSUITE="suites/tests/20_client_commands/configuration_settings"
export BEAKER_PRESUITE="suites/pre_suite/old-norestarts"
export BEAKER_CONFIG="$script_dir/hosts.cfg"
export BEAKER_KEYFILE="~/.ssh/id_rsa-acceptance"

export GENCONFIG_LAYOUT="redhat6-64mdca-64a"

export GEM_SOURCE=https://artifactory.delivery.puppetlabs.net/artifactory/api/gems/rubygems/
bundle install --path vendor/bundle

bundle exec beaker-hostgenerator $GENCONFIG_LAYOUT > $BEAKER_CONFIG

bundle exec beaker \
  --config $BEAKER_CONFIG \
  --pre-suite $BEAKER_PRESUITE \
  --tests $BEAKER_TESTSUITE \
  --keyfile $BEAKER_KEYFILE \
  --load-path lib \
  --preserve-hosts onfail \
  --debug \
  --timeout 360

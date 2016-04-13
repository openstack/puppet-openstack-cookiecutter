require 'spec_helper'

describe '{{cookiecutter.project_name}}::db::postgresql' do

  let :pre_condition do
    'include postgresql::server'
  end

  let :required_params do
    { :password => 'pw' }
  end

  shared_examples_for '{{cookiecutter.project_name}}-db-postgresql' do
    context 'with only required parameters' do
      let :params do
        required_params
      end

      it { is_expected.to contain_postgresql__server__db('{{cookiecutter.project_name}}').with(
        :user     => '{{cookiecutter.project_name}}',
        :password => 'md5c530c33636c58ae83ca933f39319273e'
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :concat_basedir => '/var/lib/puppet/concat' }))
      end

      it_behaves_like '{{cookiecutter.project_name}}-db-postgresql'
    end
  end
end

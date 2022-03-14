require 'spec_helper'

describe '{{cookiecutter.project_name}}::db::postgresql' do
  let :pre_condition do
    'include postgresql::server'
  end

  let :required_params do
    {
      :password => '{{cookiecutter.project_name}}pass'
    }
  end

  shared_examples '{{cookiecutter.project_name}}::db::postgresql' do
    context 'with only required parameters' do
      let :params do
        required_params
      end

      it { should contain_class('{{cookiecutter.project_name}}::deps') }

      it { should contain_openstacklib__db__postgresql('{{cookiecutter.project_name}}').with(
        :password   => params[:password],
        :dbname     => '{{cookiecutter.project_name}}',
        :user       => '{{cookiecutter.project_name}}',
        :privileges => 'ALL',
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

      # TODO(tkajinam): Remove this once puppet-postgresql supports CentOS 9
      unless facts[:osfamily] == 'RedHat' and facts[:operatingsystemmajrelease].to_i >= 9
        it_behaves_like '{{cookiecutter.project_name}}::db::postgresql'
      end
    end
  end
end

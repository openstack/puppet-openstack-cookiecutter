require 'spec_helper'

describe '{{cookiecutter.project_name}}::db::mysql' do
  let :pre_condition do
    'include mysql::server'
  end

  let :required_params do
    {
      :password => '{{cookiecutter.project_name}}pass'
    }
  end

  shared_examples '{{cookiecutter.project_name}}::db::mysql' do
    context 'with only required params' do
      let :params do
        required_params
      end

      it { is_expected.to contain_class('{{cookiecutter.project_name}}::deps') }

      it { should contain_openstacklib__db__mysql('{{cookiecutter.project_name}}').with(
        :user     => '{{cookiecutter.project_name}}',
        :password => '{{cookiecutter.project_name}}pass',
        :dbname   => '{{cookiecutter.project_name}}',
        :host     => '127.0.0.1',
        :charset  => 'utf8',
        :collate  => 'utf8_general_ci',
      )}
    end

    context 'overriding allowed_hosts param to array' do
      let :params do
        required_params.merge!( :allowed_hosts => ['127.0.0.1', '%'] )
      end

      it { should contain_openstacklib__db__mysql('{{cookiecutter.project_name}}').with(
        :user          => '{{cookiecutter.project_name}}',
        :password      => '{{cookiecutter.project_name}}pass',
        :dbname        => '{{cookiecutter.project_name}}',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => ['127.0.0.1','%'],
      )}
    end

    context 'overriding allowed_hosts param to string' do
      let :params do
        required_params.merge!( :allowed_hosts => '192.168.1.1' )
      end

      it { should contain_openstacklib__db__mysql('{{cookiecutter.project_name}}').with(
        :user          => '{{cookiecutter.project_name}}',
        :password      => '{{cookiecutter.project_name}}pass',
        :dbname        => '{{cookiecutter.project_name}}',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => '192.168.1.1',
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like '{{cookiecutter.project_name}}::db::mysql'
    end
  end
end

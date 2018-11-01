require 'spec_helper'

describe '{{cookiecutter.project_name}}::db' do
  shared_examples '{{cookiecutter.project_name}}::db' do
    context 'with default parameters' do
      it { should contain_oslo__db('{{cookiecutter.project_name}}_config').with(
        :connection     => 'sqlite:////var/lib/{{cookiecutter.project_name}}/{{cookiecutter.project_name}}.sqlite',
        :idle_timeout   => '<SERVICE DEFAULT>',
        :min_pool_size  => '<SERVICE DEFAULT>',
        :db_max_retries => '<SERVICE DEFAULT>',
        :max_pool_size  => '<SERVICE DEFAULT>',
        :max_retries    => '<SERVICE DEFAULT>',
        :retry_interval => '<SERVICE DEFAULT>',
        :max_overflow   => '<SERVICE DEFAULT>',
        :pool_timeout   => '<SERVICE DEFAULT>',
      )}
    end

    context 'with specific parameters' do
      let :params do
        {
          :database_connection     => 'mysql+pymysql://{{cookiecutter.project_name}}:{{cookiecutter.project_name}}@localhost/{{cookiecutter.project_name}}',
          :database_idle_timeout   => '3601',
          :database_min_pool_size  => '2',
          :database_db_max_retries => '-1',
          :database_max_retries    => '11',
          :database_retry_interval => '11',
          :database_max_pool_size  => '11',
          :database_max_overflow   => '21',
          :database_pool_timeout   => '21',
        }
      end

      it { should contain_oslo__db('{{cookiecutter.project_name}}_config').with(
        :connection     => 'mysql+pymysql://{{cookiecutter.project_name}}:{{cookiecutter.project_name}}@localhost/{{cookiecutter.project_name}}',
        :idle_timeout   => '3601',
        :min_pool_size  => '2',
        :db_max_retries => '-1',
        :max_pool_size  => '11',
        :max_retries    => '11',
        :retry_interval => '11',
        :max_overflow   => '21',
        :pool_timeout   => '21',
      )}
    end

    context 'with postgresql backend' do
      let :params do
        {
          :database_connection => 'postgresql://{{cookiecutter.project_name}}:{{cookiecutter.project_name}}@localhost/{{cookiecutter.project_name}}'
        }
      end

      it { should contain_package('python-psycopg2').with(:ensure => 'present') }
    end

    context 'with MySQL-python library as backend package' do
      let :params do
        {
          :database_connection => 'mysql://{{cookiecutter.project_name}}:{{cookiecutter.project_name}}@localhost/{{cookiecutter.project_name}}'
        }
      end

      it { should contain_package('python-mysqldb').with(:ensure => 'present') }
    end

    context 'with incorrect database_connection string' do
      let :params do
        {
          :database_connection => 'foodb://{{cookiecutter.project_name}}:{{cookiecutter.project_name}}@localhost/{{cookiecutter.project_name}}'
        }
      end

      it { should raise_error(Puppet::Error, /validate_re/) }
    end

    context 'with incorrect pymysql database_connection string' do
      let :params do
        {
          :database_connection => 'foo+pymysql://{{cookiecutter.project_name}}:{{cookiecutter.project_name}}@localhost/{{cookiecutter.project_name}}'
        }
      end

      it { should raise_error(Puppet::Error, /validate_re/) }
    end
  end

  shared_examples '{{cookiecutter.project_name}}::db on Debian' do
    context 'using pymysql driver' do
      let :params do
        {
          :database_connection => 'mysql+pymysql://{{cookiecutter.project_name}}:{{cookiecutter.project_name}}@localhost/{{cookiecutter.project_name}}'
        }
      end

      it { should contain_package('python-pymysql').with(
        :ensure => 'present',
        :name   => 'python-pymysql',
        :tag    => 'openstack'
      )}
    end
  end

  shared_examples '{{cookiecutter.project_name}}::db on RedHat' do
    context 'using pymysql driver' do
      let :params do
        {
          :database_connection => 'mysql+pymysql://{{cookiecutter.project_name}}:{{cookiecutter.project_name}}@localhost/{{cookiecutter.project_name}}'
        }
      end

      it { should_not contain_package('python-pymysql') }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like '{{cookiecutter.project_name}}::db'
      it_behaves_like "{{cookiecutter.project_name}}::db on #{facts[:osfamily]}"
    end
  end
end

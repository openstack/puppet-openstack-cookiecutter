require 'spec_helper'

describe '{{cookiecutter.project_name}}::db::postgresql' do

  let :req_params do
    { :password => 'pw' }
  end

  let :pre_condition do
    'include postgresql::server'
  end

  context 'on a RedHat osfamily' do
    let :facts do
      {
        :osfamily                 => 'RedHat',
        :operatingsystemrelease   => '7.0',
        :concat_basedir => '/var/lib/puppet/concat'
      }
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_postgresql__server__db('{{cookiecutter.project_name}}').with(
        :user     => '{{cookiecutter.project_name}}',
        :password => 'md5c530c33636c58ae83ca933f39319273e'
      )}
    end

  end

  context 'on a Debian osfamily' do
    let :facts do
      {
        :operatingsystemrelease => '7.8',
        :operatingsystem        => 'Debian',
        :osfamily               => 'Debian',
        :concat_basedir => '/var/lib/puppet/concat'
      }
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_postgresql__server__db('{{cookiecutter.project_name}}').with(
        :user     => '{{cookiecutter.project_name}}',
        :password => 'md5c530c33636c58ae83ca933f39319273e'
      )}
    end

  end

end

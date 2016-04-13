#
# Unit tests for {{cookiecutter.project_name}}::keystone::auth
#

require 'spec_helper'

describe '{{cookiecutter.project_name}}::keystone::auth' do
  shared_examples_for '{{cookiecutter.project_name}}-keystone-auth' do
    context 'with default class parameters' do
      let :params do
        { :password => '{{cookiecutter.project_name}}_password',
          :tenant   => 'foobar' }
      end

      it { is_expected.to contain_keystone_user('{{cookiecutter.project_name}}').with(
        :ensure   => 'present',
        :password => '{{cookiecutter.project_name}}_password',
      ) }

      it { is_expected.to contain_keystone_user_role('{{cookiecutter.project_name}}@foobar').with(
        :ensure  => 'present',
        :roles   => ['admin']
      )}

      it { is_expected.to contain_keystone_service('{{cookiecutter.project_name}}::FIXME').with(
        :ensure      => 'present',
        :description => '{{cookiecutter.project_name}} FIXME Service'
      ) }

      it { is_expected.to contain_keystone_endpoint('RegionOne/{{cookiecutter.project_name}}::FIXME').with(
        :ensure       => 'present',
        :public_url   => 'http://127.0.0.1:FIXME',
        :admin_url    => 'http://127.0.0.1:FIXME',
        :internal_url => 'http://127.0.0.1:FIXME',
      ) }
    end

    context 'when overriding URL parameters' do
      let :params do
        { :password     => '{{cookiecutter.project_name}}_password',
          :public_url   => 'https://10.10.10.10:80',
          :internal_url => 'http://10.10.10.11:81',
          :admin_url    => 'http://10.10.10.12:81', }
      end

      it { is_expected.to contain_keystone_endpoint('RegionOne/{{cookiecutter.project_name}}::FIXME').with(
        :ensure       => 'present',
        :public_url   => 'https://10.10.10.10:80',
        :internal_url => 'http://10.10.10.11:81',
        :admin_url    => 'http://10.10.10.12:81',
      ) }
    end

    context 'when overriding auth name' do
      let :params do
        { :password => 'foo',
          :auth_name => '{{cookiecutter.project_name}}y' }
      end

      it { is_expected.to contain_keystone_user('{{cookiecutter.project_name}}y') }
      it { is_expected.to contain_keystone_user_role('{{cookiecutter.project_name}}y@services') }
      it { is_expected.to contain_keystone_service('{{cookiecutter.project_name}}y::FIXME') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/{{cookiecutter.project_name}}y::FIXME') }
    end

    context 'when overriding service name' do
      let :params do
        { :service_name => '{{cookiecutter.project_name}}_service',
          :auth_name    => '{{cookiecutter.project_name}}',
          :password     => '{{cookiecutter.project_name}}_password' }
      end

      it { is_expected.to contain_keystone_user('{{cookiecutter.project_name}}') }
      it { is_expected.to contain_keystone_user_role('{{cookiecutter.project_name}}@services') }
      it { is_expected.to contain_keystone_service('{{cookiecutter.project_name}}_service::FIXME') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/{{cookiecutter.project_name}}_service::FIXME') }
    end

    context 'when disabling user configuration' do

      let :params do
        {
          :password       => '{{cookiecutter.project_name}}_password',
          :configure_user => false
        }
      end

      it { is_expected.not_to contain_keystone_user('{{cookiecutter.project_name}}') }
      it { is_expected.to contain_keystone_user_role('{{cookiecutter.project_name}}@services') }
      it { is_expected.to contain_keystone_service('{{cookiecutter.project_name}}::FIXME').with(
        :ensure      => 'present',
        :description => '{{cookiecutter.project_name}} FIXME Service'
      ) }

    end

    context 'when disabling user and user role configuration' do

      let :params do
        {
          :password            => '{{cookiecutter.project_name}}_password',
          :configure_user      => false,
          :configure_user_role => false
        }
      end

      it { is_expected.not_to contain_keystone_user('{{cookiecutter.project_name}}') }
      it { is_expected.not_to contain_keystone_user_role('{{cookiecutter.project_name}}@services') }
      it { is_expected.to contain_keystone_service('{{cookiecutter.project_name}}::FIXME').with(
        :ensure      => 'present',
        :description => '{{cookiecutter.project_name}} FIXME Service'
      ) }

    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like '{{cookiecutter.project_name}}-keystone-auth'
    end
  end
end

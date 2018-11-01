#
# Unit tests for {{cookiecutter.project_name}}::keystone::auth
#

require 'spec_helper'

describe '{{cookiecutter.project_name}}::keystone::auth' do
  shared_examples '{{cookiecutter.project_name}}-keystone-auth' do
    context 'with default class parameters' do
      let :params do
        {
          :password => '{{cookiecutter.project_name}}_password',
          :tenant   => 'foobar'
        }
      end

      it { should contain_keystone_user('{{cookiecutter.project_name}}').with(
        :ensure   => 'present',
        :password => '{{cookiecutter.project_name}}_password',
      )}

      it { should contain_keystone_user_role('{{cookiecutter.project_name}}@foobar').with(
        :ensure  => 'present',
        :roles   => ['admin']
      )}

      it { should contain_keystone_service('{{cookiecutter.project_name}}::FIXME').with(
        :ensure      => 'present',
        :description => '{{cookiecutter.project_name}} FIXME Service'
      )}

      it { should contain_keystone_endpoint('RegionOne/{{cookiecutter.project_name}}::FIXME').with(
        :ensure       => 'present',
        :public_url   => 'http://127.0.0.1:FIXME',
        :admin_url    => 'http://127.0.0.1:FIXME',
        :internal_url => 'http://127.0.0.1:FIXME',
      )}
    end

    context 'when overriding URL parameters' do
      let :params do
        {
          :password     => '{{cookiecutter.project_name}}_password',
          :public_url   => 'https://10.10.10.10:80',
          :internal_url => 'http://10.10.10.11:81',
          :admin_url    => 'http://10.10.10.12:81'
        }
      end

      it { should contain_keystone_endpoint('RegionOne/{{cookiecutter.project_name}}::FIXME').with(
        :ensure       => 'present',
        :public_url   => 'https://10.10.10.10:80',
        :internal_url => 'http://10.10.10.11:81',
        :admin_url    => 'http://10.10.10.12:81',
      )}
    end

    context 'when overriding auth name' do
      let :params do
        {
          :password  => 'foo',
          :auth_name => '{{cookiecutter.project_name}}'
        }
      end

      it { should contain_keystone_user('{{cookiecutter.project_name}}') }
      it { should contain_keystone_user_role('{{cookiecutter.project_name}}@services') }
      it { should contain_keystone_service('{{cookiecutter.project_name}}::FIXME') }
      it { should contain_keystone_endpoint('RegionOne/{{cookiecutter.project_name}}::FIXME') }
    end

    context 'when overriding service name' do
      let :params do
        {
          :service_name => '{{cookiecutter.project_name}}_service',
          :auth_name    => '{{cookiecutter.project_name}}',
          :password     => '{{cookiecutter.project_name}}_password'
        }
      end

      it { should contain_keystone_user('{{cookiecutter.project_name}}') }
      it { should contain_keystone_user_role('{{cookiecutter.project_name}}@services') }
      it { should contain_keystone_service('{{cookiecutter.project_name}}_service::FIXME') }
      it { should contain_keystone_endpoint('RegionOne/{{cookiecutter.project_name}}_service::FIXME') }
    end

    context 'when disabling user configuration' do
      let :params do
        {
          :password       => '{{cookiecutter.project_name}}_password',
          :configure_user => false
        }
      end

      it { should_not contain_keystone_user('{{cookiecutter.project_name}}') }
      it { should contain_keystone_user_role('{{cookiecutter.project_name}}@services') }

      it { should contain_keystone_service('{{cookiecutter.project_name}}::FIXME').with(
        :ensure      => 'present',
        :description => '{{cookiecutter.project_name}} FIXME Service'
      )}
    end

    context 'when disabling user and user role configuration' do
      let :params do
        {
          :password            => '{{cookiecutter.project_name}}_password',
          :configure_user      => false,
          :configure_user_role => false
        }
      end

      it { should_not contain_keystone_user('{{cookiecutter.project_name}}') }
      it { should_not contain_keystone_user_role('{{cookiecutter.project_name}}@services') }

      it { should contain_keystone_service('{{cookiecutter.project_name}}::FIXME').with(
        :ensure      => 'present',
        :description => '{{cookiecutter.project_name}} FIXME Service'
      )}
    end

    context 'when using ensure absent' do
      let :params do
        {
          :password => '{{cookiecutter.project_name}}_password',
          :ensure   => 'absent'
        }
      end

      it { should contain_keystone__resource__service_identity('{{cookiecutter.project_name}}').with_ensure('absent') }
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

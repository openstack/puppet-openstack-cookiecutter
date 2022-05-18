#
# Unit tests for {{cookiecutter.project_name}}::keystone::auth
#

require 'spec_helper'

describe '{{cookiecutter.project_name}}::keystone::auth' do
  shared_examples '{{cookiecutter.project_name}}::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        { :password => '{{cookiecutter.project_name}}_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('{{cookiecutter.project_name}}').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => true,
        :service_name        => '{{cookiecutter.project_name}}',
        :service_type        => 'FIXME',
        :service_description => 'OpenStack FIXME Service',
        :region              => 'RegionOne',
        :auth_name           => '{{cookiecutter.project_name}}',
        :password            => '{{cookiecutter.project_name}}_password',
        :email               => '{{cookiecutter.project_name}}@localhost',
        :tenant              => 'services',
        :roles               => ['admin'],
        :system_scope        => 'all',
        :system_roles        => [],
        :public_url          => 'http://127.0.0.1:FIXME',
        :internal_url        => 'http://127.0.0.1:FIXME',
        :admin_url           => 'http://127.0.0.1:FIXME',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => '{{cookiecutter.project_name}}_password',
          :auth_name           => 'alt_{{cookiecutter.project_name}}',
          :email               => 'alt_{{cookiecutter.project_name}}@alt_localhost',
          :tenant              => 'alt_service',
          :roles               => ['admin', 'service'],
          :system_scope        => 'alt_all',
          :system_roles        => ['admin', 'member', 'reader'],
          :configure_endpoint  => false,
          :configure_user      => false,
          :configure_user_role => false,
          :service_description => 'Alternative OpenStack FIXME Service',
          :service_name        => 'alt_service',
          :service_type        => 'alt_FIXME',
          :region              => 'RegionTwo',
          :public_url          => 'https://10.10.10.10:80',
          :internal_url        => 'http://10.10.10.11:81',
          :admin_url           => 'http://10.10.10.12:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('{{cookiecutter.project_name}}').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_FIXME',
        :service_description => 'Alternative OpenStack FIXME Service',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_{{cookiecutter.project_name}}',
        :password            => '{{cookiecutter.project_name}}_password',
        :email               => 'alt_{{cookiecutter.project_name}}@alt_localhost',
        :tenant              => 'alt_service',
        :roles               => ['admin', 'service'],
        :system_scope        => 'alt_all',
        :system_roles        => ['admin', 'member', 'reader'],
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
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

      it_behaves_like '{{cookiecutter.project_name}}::keystone::auth'
    end
  end
end

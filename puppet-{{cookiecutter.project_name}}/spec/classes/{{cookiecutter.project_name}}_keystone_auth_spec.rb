#
# Unit tests for {{cookiecutter.project_name}}::keystone::auth
#

require 'spec_helper'

describe '{{cookiecutter.project_name}}::keystone::auth' do

  let :facts do
    { :osfamily => 'Debian' }
  end

  describe 'with default class parameters' do
    let :params do
      { :password => '{{cookiecutter.project_name}}_password',
        :tenant   => 'foobar' }
    end

    it { is_expected.to contain_keystone_user('{{cookiecutter.project_name}}').with(
      :ensure   => 'present',
      :password => '{{cookiecutter.project_name}}_password',
      :tenant   => 'foobar'
    ) }

    it { is_expected.to contain_keystone_user_role('{{cookiecutter.project_name}}@foobar').with(
      :ensure  => 'present',
      :roles   => ['admin']
    )}

    it { is_expected.to contain_keystone_service('{{cookiecutter.project_name}}').with(
      :ensure      => 'present',
      :type        => 'FIXME',
      :description => '{{cookiecutter.project_name}} FIXME Service'
    ) }

    it { is_expected.to contain_keystone_endpoint('RegionOne/{{cookiecutter.project_name}}').with(
      :ensure       => 'present',
      :public_url   => 'http://127.0.0.1:FIXME',
      :admin_url    => 'http://127.0.0.1:FIXME',
      :internal_url => 'http://127.0.0.1:FIXME',
    ) }
  end

  describe 'when overriding URL paramaters' do
    let :params do
      { :password     => '{{cookiecutter.project_name}}_password',
        :public_url   => 'https://10.10.10.10:80',
        :internal_url => 'http://10.10.10.11:81',
        :admin_url    => 'http://10.10.10.12:81', }
    end

    it { is_expected.to contain_keystone_endpoint('RegionOne/{{cookiecutter.project_name}}').with(
      :ensure       => 'present',
      :public_url   => 'https://10.10.10.10:80',
      :internal_url => 'http://10.10.10.11:81',
      :admin_url    => 'http://10.10.10.12:81',
    ) }
  end

  describe 'when overriding auth name' do
    let :params do
      { :password => 'foo',
        :auth_name => '{{cookiecutter.project_name}}y' }
    end

    it { is_expected.to contain_keystone_user('{{cookiecutter.project_name}}y') }
    it { is_expected.to contain_keystone_user_role('{{cookiecutter.project_name}}y@services') }
    it { is_expected.to contain_keystone_service('{{cookiecutter.project_name}}y') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/{{cookiecutter.project_name}}y') }
  end

  describe 'when overriding service name' do
    let :params do
      { :service_name => '{{cookiecutter.project_name}}_service',
        :auth_name    => '{{cookiecutter.project_name}}',
        :password     => '{{cookiecutter.project_name}}_password' }
    end

    it { is_expected.to contain_keystone_user('{{cookiecutter.project_name}}') }
    it { is_expected.to contain_keystone_user_role('{{cookiecutter.project_name}}@services') }
    it { is_expected.to contain_keystone_service('{{cookiecutter.project_name}}_service') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/{{cookiecutter.project_name}}_service') }
  end

  describe 'when disabling user configuration' do

    let :params do
      {
        :password       => '{{cookiecutter.project_name}}_password',
        :configure_user => false
      }
    end

    it { is_expected.not_to contain_keystone_user('{{cookiecutter.project_name}}') }
    it { is_expected.to contain_keystone_user_role('{{cookiecutter.project_name}}@services') }
    it { is_expected.to contain_keystone_service('{{cookiecutter.project_name}}').with(
      :ensure      => 'present',
      :type        => 'FIXME',
      :description => '{{cookiecutter.project_name}} FIXME Service'
    ) }

  end

  describe 'when disabling user and user role configuration' do

    let :params do
      {
        :password            => '{{cookiecutter.project_name}}_password',
        :configure_user      => false,
        :configure_user_role => false
      }
    end

    it { is_expected.not_to contain_keystone_user('{{cookiecutter.project_name}}') }
    it { is_expected.not_to contain_keystone_user_role('{{cookiecutter.project_name}}@services') }
    it { is_expected.to contain_keystone_service('{{cookiecutter.project_name}}').with(
      :ensure      => 'present',
      :type        => 'FIXME',
      :description => '{{cookiecutter.project_name}} FIXME Service'
    ) }

  end

end

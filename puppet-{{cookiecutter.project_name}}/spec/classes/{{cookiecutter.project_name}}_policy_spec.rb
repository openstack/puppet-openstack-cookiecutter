require 'spec_helper'

describe '{{cookiecutter.project_name}}::policy' do
  shared_examples '{{cookiecutter.project_name}}::policy' do

    context 'setup policy with parameters' do
      let :params do
        {
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_path          => '/etc/{{cookiecutter.project_name}}/policy.yaml',
          :policy_default_rule  => 'default',
          :policy_dirs          => '/etc/{{cookiecutter.project_name}}/policy.d',
          :policies             => {
            'context_is_admin' => {
              'key'   => 'context_is_admin',
              'value' => 'foo:bar'
            }
          }
        }
      end

      it 'set up the policies' do
        is_expected.to contain_openstacklib__policy('/etc/{{cookiecutter.project_name}}/policy.yaml').with(
          :policies     => {
            'context_is_admin' => {
              'key'   => 'context_is_admin',
              'value' => 'foo:bar'
            }
          },
          :policy_path  => '/etc/{{cookiecutter.project_name}}/policy.yaml',
          :file_user    => 'root',
          :file_group   => '{{cookiecutter.project_name}}',
          :file_format  => 'yaml',
          :purge_config => false,
          :tag          => '{{cookiecutter.project_name}}',
        )
        is_expected.to contain_oslo__policy('{{cookiecutter.project_name}}_config').with(
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_file          => '/etc/{{cookiecutter.project_name}}/policy.yaml',
          :policy_default_rule  => 'default',
          :policy_dirs          => '/etc/{{cookiecutter.project_name}}/policy.d',
        )
      end
    end

    context 'with empty policies and purge_config enabled' do
      let :params do
        {
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_path          => '/etc/{{cookiecutter.project_name}}/policy.yaml',
          :policies             => {},
          :purge_config         => true,
        }
      end

      it 'set up the policies' do
        is_expected.to contain_openstacklib__policy('/etc/{{cookiecutter.project_name}}/policy.yaml').with(
          :policies     => {},
          :policy_path  => '/etc/{{cookiecutter.project_name}}/policy.yaml',
          :file_user    => 'root',
          :file_group   => '{{cookiecutter.project_name}}',
          :file_format  => 'yaml',
          :purge_config => true,
          :tag          => '{{cookiecutter.project_name}}',
        )
        is_expected.to contain_oslo__policy('{{cookiecutter.project_name}}_config').with(
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_file          => '/etc/{{cookiecutter.project_name}}/policy.yaml',
        )
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like '{{cookiecutter.project_name}}::policy'
    end
  end
end

require 'spec_helper'

describe '{{cookiecutter.project_name}}::policy' do
  shared_examples '{{cookiecutter.project_name}}-policies' do
    let :params do
      {
        :policy_path => '/etc/{{cookiecutter.project_name}}/policy.json',
        :policies    => {
          'context_is_admin' => {
            'key'   => 'context_is_admin',
            'value' => 'foo:bar'
          }
        }
      }
    end

    it { should contain_openstacklib__policy__base('context_is_admin').with(
      :key        => 'context_is_admin',
      :value      => 'foo:bar',
      :file_user  => 'root',
      :file_group => '{{cookiecutter.project_name}}',
    )}
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like '{{cookiecutter.project_name}}-policies'
    end
  end
end

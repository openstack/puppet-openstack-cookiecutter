require 'spec_helper'

describe '{{cookiecutter.project_name}}::db::sync' do
  shared_examples '{{cookiecutter.project_name}}-dbsync' do

    it { is_expected.to contain_class('{{cookiecutter.project_name}}::deps') }

    it { should contain_exec('{{cookiecutter.project_name}}-db-sync').with(
      :command     => '{{cookiecutter.project_name}}-manage db_sync ',
      :path        => [ '/bin', '/usr/bin', ],
      :refreshonly => 'true',
      :try_sleep   => 5,
      :tries       => 10,
      :user        => '{{cookiecutter.project_name}}',
      :logoutput   => 'on_failure',
      :subscribe   => [
        'Anchor[{{cookiecutter.project_name}}::install::end]',
        'Anchor[{{cookiecutter.project_name}}::config::end]',
        'Anchor[{{cookiecutter.project_name}}::dbsync::begin]'
      ],
      :notify      => 'Anchor[{{cookiecutter.project_name}}::dbsync::end]',
      :tag         => 'openstack-db',
    )}
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :os_workers     => 8,
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_behaves_like '{{cookiecutter.project_name}}-dbsync'
    end
  end
end

require 'spec_helper'

describe '{{cookiecutter.project_name}}::logging' do
  let :params do
    {}
  end

  let :log_params do
    {
      :logging_context_format_string => '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [%(request_id)s %(user_identity)s] %(instance)s%(message)s',
      :logging_default_format_string => '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [-] %(instance)s%(message)s',
      :logging_debug_format_suffix   => '%(funcName)s %(pathname)s:%(lineno)d',
      :logging_exception_prefix      => '%(asctime)s.%(msecs)03d %(process)d TRACE %(name)s %(instance)s',
      :log_config_append             => '/etc/{{cookiecutter.project_name}}/logging.conf',
      :publish_errors                => true,
      :default_log_levels            => {
        'amqp' => 'WARN', 'amqplib' => 'WARN', 'boto' => 'WARN',
        'sqlalchemy' => 'WARN', 'suds' => 'INFO', 'iso8601' => 'WARN',
        'requests.packages.urllib3.connectionpool' => 'WARN' },
      :fatal_deprecations            => true,
      :instance_format               => '[instance: %(uuid)s] ',
      :instance_uuid_format          => '[instance: %(uuid)s] ',
      :log_date_format               => '%Y-%m-%d %H:%M:%S',
      :use_syslog                    => true,
      :use_json                      => true,
      :use_journal                   => true,
      :use_stderr                    => false,
      :syslog_log_facility           => 'LOG_FOO',
      :log_dir                       => '/var/log',
      :log_file                      => '/var/tmp/{{cookiecutter.project_name}}_random.log',
      :watch_log_file                => true,
      :debug                         => true,
    }
  end

  shared_examples '{{cookiecutter.project_name}}-logging' do
    context 'with basic logging options and default settings' do
      it_behaves_like 'basic default logging settings'
    end

    context 'with basic logging options and non-default settings' do
      before do
        params.merge!( log_params )
      end

      it_behaves_like 'basic non-default logging settings'
    end

    context 'with extended logging options' do
      before do
        params.merge!( log_params )
      end

      it_behaves_like 'logging params set'
    end

    context 'without extended logging options' do
      it_behaves_like 'logging params unset'
    end
  end

  shared_examples 'basic default logging settings' do
    it { should contain_oslo__log('{{cookiecutter.project_name}}_config').with(
      :use_syslog          => '<SERVICE DEFAULT>',
      :use_json            => '<SERVICE DEFAULT>',
      :use_journal         => '<SERVICE DEFAULT>',
      :use_stderr          => '<SERVICE DEFAULT>',
      :syslog_log_facility => '<SERVICE DEFAULT>',
      :log_dir             => '/var/log/{{cookiecutter.project_name}}',
      :log_file            => '/var/log/{{cookiecutter.project_name}}/{{cookiecutter.project_name}}.log',
      :watch_log_file      => '<SERVICE DEFAULT>',
      :debug               => '<SERVICE DEFAULT>',
    )}
  end

  shared_examples 'basic non-default logging settings' do
    it { should contain_oslo__log('{{cookiecutter.project_name}}_config').with(
      :use_syslog          => true,
      :use_json            => true,
      :use_journal         => true,
      :use_stderr          => false,
      :syslog_log_facility => 'LOG_FOO',
      :log_dir             => '/var/log',
      :log_file            => '/var/tmp/{{cookiecutter.project_name}}_random.log',
      :watch_log_file      => true,
      :debug               => true,
    )}
  end

  shared_examples 'logging params set' do
    it { should contain_oslo__log('{{cookiecutter.project_name}}_config').with(
      :logging_context_format_string =>
        '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [%(request_id)s %(user_identity)s] %(instance)s%(message)s',
      :logging_default_format_string => '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [-] %(instance)s%(message)s',
      :logging_debug_format_suffix   => '%(funcName)s %(pathname)s:%(lineno)d',
      :logging_exception_prefix      => '%(asctime)s.%(msecs)03d %(process)d TRACE %(name)s %(instance)s',
      :log_config_append             => '/etc/{{cookiecutter.project_name}}/logging.conf',
      :publish_errors                => true,
      :default_log_levels            => {
        'amqp' => 'WARN', 'amqplib' => 'WARN', 'boto' => 'WARN',
        'sqlalchemy' => 'WARN', 'suds' => 'INFO', 'iso8601' => 'WARN',
        'requests.packages.urllib3.connectionpool' => 'WARN' },
     :fatal_deprecations             => true,
     :instance_format                => '[instance: %(uuid)s] ',
     :instance_uuid_format           => '[instance: %(uuid)s] ',
     :log_date_format                => '%Y-%m-%d %H:%M:%S',
    )}
  end

  shared_examples 'logging params unset' do
   [ :logging_context_format_string, :logging_default_format_string,
     :logging_debug_format_suffix, :logging_exception_prefix,
     :log_config_append, :publish_errors,
     :default_log_levels, :fatal_deprecations,
     :instance_format, :instance_uuid_format,
     :log_date_format, ].each { |param|
        it { should contain_oslo__log('{{cookiecutter.project_name}}_config').with("#{param}" => '<SERVICE DEFAULT>') }
      }
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like '{{cookiecutter.project_name}}-logging'
    end
  end
end

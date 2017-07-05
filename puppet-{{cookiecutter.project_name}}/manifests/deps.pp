# == Class: {{cookiecutter.project_name}}::deps
#
# {{cookiecutter.project_name}} anchors and dependency management
#
class {{cookiecutter.project_name}}::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { '{{cookiecutter.project_name}}::install::begin': }
  -> Package<| tag == '{{cookiecutter.project_name}}-package'|>
  ~> anchor { '{{cookiecutter.project_name}}::install::end': }
  -> anchor { '{{cookiecutter.project_name}}::config::begin': }
  -> {{cookiecutter.project_name|capitalize}}_config<||>
  ~> anchor { '{{cookiecutter.project_name}}::config::end': }
  -> anchor { '{{cookiecutter.project_name}}::db::begin': }
  -> anchor { '{{cookiecutter.project_name}}::db::end': }
  ~> anchor { '{{cookiecutter.project_name}}::dbsync::begin': }
  -> anchor { '{{cookiecutter.project_name}}::dbsync::end': }
  ~> anchor { '{{cookiecutter.project_name}}::service::begin': }
  ~> Service<| tag == '{{cookiecutter.project_name}}-service' |>
  ~> anchor { '{{cookiecutter.project_name}}::service::end': }

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['{{cookiecutter.project_name}}::dbsync::begin']

  # policy config should occur in the config block also.
  Anchor['{{cookiecutter.project_name}}::config::begin']
  -> Openstacklib::Policy::Base<||>
  ~> Anchor['{{cookiecutter.project_name}}::config::end']

  # Installation or config changes will always restart services.
  Anchor['{{cookiecutter.project_name}}::install::end'] ~> Anchor['{{cookiecutter.project_name}}::service::begin']
  Anchor['{{cookiecutter.project_name}}::config::end']  ~> Anchor['{{cookiecutter.project_name}}::service::begin']
}

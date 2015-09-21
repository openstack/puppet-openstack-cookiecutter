#
# Class to execute {{cookiecutter.project_name}}-manage db_sync
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the {{cookiecutter.project_name}}-dbsync command.
#   Defaults to undef
#
class {{cookiecutter.project_name}}::db::sync(
  $extra_params  = undef,
) {
  exec { '{{cookiecutter.project_name}}-db-sync':
    command     => "{{cookiecutter.project_name}}-manage db_sync ${extra_params}",
    path        => '/usr/bin',
    user        => '{{cookiecutter.project_name}}',
    refreshonly => true,
    subscribe   => [Package['{{cookiecutter.project_name}}'], {{cookiecutter.project_name|capitalize}}_config['database/connection']],
    require     => User['{{cookiecutter.project_name}}'],
  }

  Exec['{{cookiecutter.project_name}}-manage db_sync'] ~> Service<| title == '{{cookiecutter.project_name}}' |>
}

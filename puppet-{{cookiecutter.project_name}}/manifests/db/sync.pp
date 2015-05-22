#
# Class to execute "{{cookiecutter.project_name}}-manage db_sync
#
class {{cookiecutter.project_name}}::db::sync {
  exec { '{{cookiecutter.project_name}}-manage db_sync':
    path        => '/usr/bin',
    user        => '{{cookiecutter.project_name}}',
    refreshonly => true,
    subscribe   => [Package['{{cookiecutter.project_name}}'], {{cookiecutter.project_name|capitalize}}_config['database/connection']],
    require     => User['{{cookiecutter.project_name}}'],
  }

  Exec['{{cookiecutter.project_name}}-manage db_sync'] ~> Service<| title == '{{cookiecutter.project_name}}' |>
}

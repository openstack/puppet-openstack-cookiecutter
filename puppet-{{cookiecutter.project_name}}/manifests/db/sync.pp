#
# Class to execute {{cookiecutter.project_name}}-manage db_sync
#
# == Parameters
#
# [*extra_params*]
#   (Optional) String of extra command line parameters to append
#   to the {{cookiecutter.project_name}}-dbsync command.
#   Defaults to undef
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class {{cookiecutter.project_name}}::db::sync (
  $extra_params    = undef,
  $db_sync_timeout = 300,
) {
  include {{cookiecutter.project_name}}::deps
  include {{cookiecutter.project_name}}::params

  exec { '{{cookiecutter.project_name}}-db-sync':
    command     => "{{cookiecutter.project_name}}-manage db_sync ${extra_params}",
    path        => ['/bin', '/usr/bin'],
    user        => ${{cookiecutter.project_name}}::params::user,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['{{cookiecutter.project_name}}::install::end'],
      Anchor['{{cookiecutter.project_name}}::config::end'],
      Anchor['{{cookiecutter.project_name}}::dbsync::begin']
    ],
    notify      => Anchor['{{cookiecutter.project_name}}::dbsync::end'],
    tag         => 'openstack-db',
  }
}

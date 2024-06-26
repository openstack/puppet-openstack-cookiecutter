# == Class: {{cookiecutter.project_name}}::db
#
#  Configure the {{cookiecutter.project_name}} database
#
# === Parameters
#
# [*database_connection*]
#   (Optional) Url used to connect to database.
#   Defaults to 'sqlite:////var/lib/{{cookiecutter.project_name}}/{{cookiecutter.project_name}}.sqlite'.
#
# [*database_connection_recycle_time*]
#   (Optional) Timeout when db connections should be reaped.
#   Defaults to $facts['os_service_default']
#
# [*database_db_max_retries*]
#   (optional) Maximum retries in case of connection error or deadlock error
#   before error is raised. Set to -1 to specify an infinite retry count.
#   Defaults to $facts['os_service_default']
#
# [*database_max_retries*]
#   (Optional) Maximum number of database connection retries during startup.
#   Setting -1 implies an infinite retry count.
#   Defaults to $facts['os_service_default']
#
# [*database_retry_interval*]
#   (Optional) Interval between retries of opening a database connection.
#   Defaults to $facts['os_service_default']
#
# [*database_max_pool_size*]
#   (Optional)Maximum number of SQL connections to keep open in a pool.
#   Defaults to $facts['os_service_default']
#
# [*database_max_overflow*]
#   (Optional) If set, use this value for max_overflow with sqlalchemy.
#   Defaults to $facts['os_service_default']
#
# [*database_pool_timeout*]
#   (Optional) If set, use this value for pool_timeout with SQLAlchemy.
#   Defaults to $facts['os_service_default']
#
class {{cookiecutter.project_name}}::db (
  $database_connection              = 'sqlite:////var/lib/{{cookiecutter.project_name}}/{{cookiecutter.project_name}}.sqlite',
  $database_connection_recycle_time = $facts['os_service_default'],
  $database_max_pool_size           = $facts['os_service_default'],
  $database_db_max_retries          = $facts['os_service_default'],
  $database_max_retries             = $facts['os_service_default'],
  $database_retry_interval          = $facts['os_service_default'],
  $database_max_overflow            = $facts['os_service_default'],
  $database_pool_timeout            = $facts['os_service_default'],
) {

  include {{cookiecutter.project_name}}::deps

  oslo::db { '{{cookiecutter.project_name}}_config':
    connection              => $database_connection,
    connection_recycle_time => $database_connection_recycle_time,
    db_max_retries          => $database_db_max_retries,
    max_retries             => $database_max_retries,
    retry_interval          => $database_retry_interval,
    max_pool_size           => $database_max_pool_size,
    max_overflow            => $database_max_overflow,
    pool_timeout            => $database_pool_timeout,
  }

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db['{{cookiecutter.project_name}}_config'] -> Anchor['{{cookiecutter.project_name}}::dbsync::begin']
}

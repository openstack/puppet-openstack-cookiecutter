# The {{cookiecutter.project_name}}::db::mysql class implements mysql backend for {{cookiecutter.project_name}}
#
# This class can be used to create tables, users and grant
# privilege for a mysql {{cookiecutter.project_name}} database.
#
# == parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to '{{cookiecutter.project_name}}'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to '{{cookiecutter.project_name}}'.
#
# [*host*]
#   (Optional) The default source host user is allowed to connect from.
#   Defaults to '127.0.0.1'
#
# [*allowed_hosts*]
#   (Optional) Other hosts the user is allowed to connect from.
#   Defaults to 'undef'.
#
# [*charset*]
#   (Optional) The database charset.
#   Defaults to 'utf8'
#
# [*collate*]
#   (Optional) The database collate.
#   Only used with mysql modules >= 2.2.
#   Defaults to 'utf8_general_ci'
#
# == Dependencies
#   Class['mysql::server']
#
# == Examples
#
# == Authors
#
# == Copyright
#
class {{cookiecutter.project_name}}::db::mysql(
  $password,
  $dbname        = '{{cookiecutter.project_name}}',
  $user          = '{{cookiecutter.project_name}}',
  $host          = '127.0.0.1',
  $charset       = 'utf8',
  $collate       = 'utf8_general_ci',
  $allowed_hosts = undef
) {

  include ::{{cookiecutter.project_name}}::deps

  validate_string($password)

  ::openstacklib::db::mysql { '{{cookiecutter.project_name}}':
    user          => $user,
    password_hash => mysql_password($password),
    dbname        => $dbname,
    host          => $host,
    charset       => $charset,
    collate       => $collate,
    allowed_hosts => $allowed_hosts,
  }

  ::Openstacklib::Db::Mysql['{{cookiecutter.project_name}}'] ~> Exec<| title == '{{cookiecutter.project_name}}-manage db_sync' |>
}

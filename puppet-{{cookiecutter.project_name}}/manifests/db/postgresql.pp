# == Class: {{cookiecutter.project_name}}::db::postgresql
#
# Class that configures postgresql for {{cookiecutter.project_name}}
# Requires the Puppetlabs postgresql module.
#
# === Parameters
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
#  [*encoding*]
#    (Optional) The charset to use for the database.
#    Default to undef.
#
#  [*privileges*]
#    (Optional) Privileges given to the database user.
#    Default to 'ALL'
#
class {{cookiecutter.project_name}}::db::postgresql(
  $password,
  $dbname     = '{{cookiecutter.project_name}}',
  $user       = '{{cookiecutter.project_name}}',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  include {{cookiecutter.project_name}}::deps

  ::openstacklib::db::postgresql { '{{cookiecutter.project_name}}':
    password_hash => postgresql_password($user, $password),
    dbname        => $dbname,
    user          => $user,
    encoding      => $encoding,
    privileges    => $privileges,
  }

  Anchor['{{cookiecutter.project_name}}::db::begin']
  ~> Class['{{cookiecutter.project_name}}::db::postgresql']
  ~> Anchor['{{cookiecutter.project_name}}::db::end']

}

# == Class: {{cookiecutter.project_name}}::config
#
# This class is used to manage arbitrary {{cookiecutter.project_name}} configurations.
#
# === Parameters
#
# [*{{cookiecutter.project_name}}_config*]
#   (optional) Allow configuration of arbitrary {{cookiecutter.project_name}} configurations.
#   The value is an hash of {{cookiecutter.project_name}}_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   {{cookiecutter.project_name}}_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class {{cookiecutter.project_name}}::config (
  ${{cookiecutter.project_name}}_config = {},
) {

  include ::{{cookiecutter.project_name}}::deps

  validate_hash(${{cookiecutter.project_name}}_config)

  create_resources('{{cookiecutter.project_name}}_config', ${{cookiecutter.project_name}}_config)
}

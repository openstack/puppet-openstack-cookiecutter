# == Class: {{cookiecutter.project_name}}::policy
#
# Configure the {{cookiecutter.project_name}} policies
#
# === Parameters
#
# [*policies*]
#   (optional) Set of policies to configure for {{cookiecutter.project_name}}
#   Example :
#     {
#       '{{cookiecutter.project_name}}-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       '{{cookiecutter.project_name}}-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (optional) Path to the nova policy.json file
#   Defaults to /etc/{{cookiecutter.project_name}}/policy.json
#
class {{cookiecutter.project_name}}::policy (
  $policies    = {},
  $policy_path = '/etc/{{cookiecutter.project_name}}/policy.json',
) {

  include ::{{cookiecutter.project_name}}::deps
  include ::{{cookiecutter.project_name}}::params

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path  => $policy_path,
    file_user  => 'root',
    file_group => $::{{cookiecutter.project_name}}::params::group,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { '{{cookiecutter.project_name}}_config': policy_file => $policy_path }

}

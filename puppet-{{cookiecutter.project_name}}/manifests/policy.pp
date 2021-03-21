# == Class: {{cookiecutter.project_name}}::policy
#
# Configure the {{cookiecutter.project_name}} policies
#
# === Parameters
#
# [*enforce_scope*]
#  (Optional) Whether or not to enforce scope when evaluating policies.
#  Defaults to $::os_service_default.
#
# [*policies*]
#   (Optional) Set of policies to configure for {{cookiecutter.project_name}}
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
#   (Optional) Path to the {{cookiecutter.project_name}} policy.yaml file
#   Defaults to /etc/{{cookiecutter.project_name}}/policy.yaml
#
class {{cookiecutter.project_name}}::policy (
  $enforce_scope = $::os_service_default,
  $policies      = {},
  $policy_path   = '/etc/{{cookiecutter.project_name}}/policy.yaml',
) {

  include {{cookiecutter.project_name}}::deps
  include {{cookiecutter.project_name}}::params

  validate_legacy(Hash, 'validate_hash', $policies)

  Openstacklib::Policy::Base {
    file_path   => $policy_path,
    file_user   => 'root',
    file_group  => $::{{cookiecutter.project_name}}::params::group,
    file_format => 'yaml',
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { '{{cookiecutter.project_name}}_config':
    enforce_scope => $enforce_scope,
    policy_file   => $policy_path
  }

}

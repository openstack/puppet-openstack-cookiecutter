# == Class: {{cookiecutter.project_name}}::keystone::auth
#
# Configures {{cookiecutter.project_name}} user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (Required) Password for {{cookiecutter.project_name}} user.
#
# [*ensure*]
#   (Optional) Ensure state of keystone service identity.
#   Defaults to 'present'.
#
# [*auth_name*]
#   (Optional) Username for {{cookiecutter.project_name}} service.
#   Defaults to '{{cookiecutter.project_name}}'.
#
# [*email*]
#   (Optional) Email for {{cookiecutter.project_name}} user.
#   Defaults to '{{cookiecutter.project_name}}@localhost'.
#
# [*tenant*]
#   (Optional) Tenant for {{cookiecutter.project_name}} user.
#   Defaults to 'services'.
#
# [*roles*]
#   (Optional) List of roles assigned to aodh user.
#   Defaults to ['admin']
#
# [*system_scope*]
#   (Optional) Scope for system operations.
#   Defaults to 'all'
#
# [*system_roles*]
#   (Optional) List of system roles assigned to aodh user.
#   Defaults to []
#
# [*configure_endpoint*]
#   (Optional) Should {{cookiecutter.project_name}} endpoint be configured?
#   Defaults to true.
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to true.
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to true.
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'FIXME'.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to the value of '{{cookiecutter.project_name}}'.
#
# [*service_description*]
#   (Optional) Description of the service.
#   Default to 'OpenStack FIXME Service'
#
# [*public_url*]
#   (Optional) The endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:FIXME'
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:FIXME'
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   Defaults to 'http://127.0.0.1:FIXME'
#
class {{cookiecutter.project_name}}::keystone::auth (
  $password,
  $ensure              = 'present',
  $auth_name           = '{{cookiecutter.project_name}}',
  $email               = '{{cookiecutter.project_name}}@localhost',
  $tenant              = 'services',
  $roles               = ['admin'],
  $system_scope        = 'all',
  $system_roles        = [],
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_name        = '{{cookiecutter.project_name}}',
  $service_description = 'OpenStack FIXME Service',
  $service_type        = 'FIXME',
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:FIXME',
  $admin_url           = 'http://127.0.0.1:FIXME',
  $internal_url        = 'http://127.0.0.1:FIXME',
) {

  include {{cookiecutter.project_name}}::deps

  Keystone::Resource::Service_identity['{{cookiecutter.project_name}}'] -> Anchor['{{cookiecutter.project_name}}::service::end']

  keystone::resource::service_identity { '{{cookiecutter.project_name}}':
    ensure              => $ensure,
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $service_name,
    service_type        => $service_type,
    service_description => $service_description,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    roles               => $roles,
    system_scope        => $system_scope,
    system_roles        => $system_roles,
    tenant              => $tenant,
    public_url          => $public_url,
    internal_url        => $internal_url,
    admin_url           => $admin_url,
  }

}

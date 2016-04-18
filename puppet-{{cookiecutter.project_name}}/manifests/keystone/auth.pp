# == Class: {{cookiecutter.project_name}}::keystone::auth
#
# Configures {{cookiecutter.project_name}} user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (required) Password for {{cookiecutter.project_name}} user.
#
# [*auth_name*]
#   Username for {{cookiecutter.project_name}} service. Defaults to '{{cookiecutter.project_name}}'.
#
# [*email*]
#   Email for {{cookiecutter.project_name}} user. Defaults to '{{cookiecutter.project_name}}@localhost'.
#
# [*tenant*]
#   Tenant for {{cookiecutter.project_name}} user. Defaults to 'services'.
#
# [*configure_endpoint*]
#   Should {{cookiecutter.project_name}} endpoint be configured? Defaults to 'true'.
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to 'true'.
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to 'true'.
#
# [*service_type*]
#   Type of service. Defaults to 'key-manager'.
#
# [*region*]
#   Region for endpoint. Defaults to 'RegionOne'.
#
# [*service_name*]
#   (optional) Name of the service.
#   Defaults to the value of auth_name.
#
# [*service_description*]
#   (optional) Description of the service.
#   Default to '{{cookiecutter.project_name}} FIXME Service'
#
# [*public_url*]
#   (optional) The endpoint's public url. (Defaults to 'http://127.0.0.1:FIXME')
#   This url should *not* contain any trailing '/'.
#
# [*admin_url*]
#   (optional) The endpoint's admin url. (Defaults to 'http://127.0.0.1:FIXME')
#   This url should *not* contain any trailing '/'.
#
# [*internal_url*]
#   (optional) The endpoint's internal url. (Defaults to 'http://127.0.0.1:FIXME')
#
class {{cookiecutter.project_name}}::keystone::auth (
  $password,
  $auth_name           = '{{cookiecutter.project_name}}',
  $email               = '{{cookiecutter.project_name}}@localhost',
  $tenant              = 'services',
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_name        = undef,
  $service_description = '{{cookiecutter.project_name}} FIXME Service',
  $service_type        = 'FIXME',
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:FIXME',
  $admin_url           = 'http://127.0.0.1:FIXME',
  $internal_url        = 'http://127.0.0.1:FIXME',
) {

  $real_service_name = pick($service_name, $auth_name)

  if $configure_user_role {
    Keystone_user_role["${auth_name}@${tenant}"] ~> Service <| name == '{{cookiecutter.project_name}}-server' |>
  }
  Keystone_endpoint["${region}/${real_service_name}::${service_type}"]  ~> Service <| name == '{{cookiecutter.project_name}}-server' |>

  keystone::resource::service_identity { '{{cookiecutter.project_name}}':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $real_service_name,
    service_type        => $service_type,
    service_description => $service_description,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => $public_url,
    internal_url        => $internal_url,
    admin_url           => $admin_url,
  }

}

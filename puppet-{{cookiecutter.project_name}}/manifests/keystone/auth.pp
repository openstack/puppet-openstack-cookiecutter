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
#   Type of service. Defaults to 'FIXME'.
#
# [*public_protocol*]
#   Protocol for public endpoint. Defaults to 'http'.
#
# [*public_address*]
#   Public address for endpoint. Defaults to '127.0.0.1'.
#
# [*admin_protocol*]
#   Protocol for admin endpoint. Defaults to 'http'.
#
# [*admin_address*]
#   Admin address for endpoint. Defaults to '127.0.0.1'.
#
# [*internal_protocol*]
#   Protocol for internal endpoint. Defaults to 'http'.
#
# [*internal_address*]
#   Internal address for endpoint. Defaults to '127.0.0.1'.
#
# [*port*]
#   Port for endpoint. Defaults to 'FIXME'.
#
# [*public_port*]
#   Port for public endpoint. Defaults to $port.
#
# [*region*]
#   Region for endpoint. Defaults to 'RegionOne'.
#
# [*service_name*]
#   (optional) Name of the service.
#   Defaults to the value of auth_name.
#
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
  $service_type        = 'FIXME',
  $public_protocol     = 'http',
  $public_address      = '127.0.0.1',
  $admin_protocol      = 'http',
  $admin_address       = '127.0.0.1',
  $internal_protocol   = 'http',
  $internal_address    = '127.0.0.1',
  $port                = 'FIXME',
  $public_port         = undef,
  $region              = 'RegionOne'
) {

  $real_service_name    = pick($service_name, $auth_name)

  if $configure_user_role {
    Keystone_user_role["${auth_name}@${tenant}"] ~> Service <| name == '{{cookiecutter.project_name}}-server' |>
  }
  Keystone_endpoint["${region}/${real_service_name}"]  ~> Service <| name == '{{cookiecutter.project_name}}-server' |>

  if ! $public_port {
    $real_public_port = $port
  } else {
    $real_public_port = $public_port
  }

  keystone::resource::service_identity { '{{cookiecutter.project_name}}':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $real_service_name,
    service_type        => $service_type,
    service_description => '{{cookiecutter.project_name}} FIXME Service',
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => "${public_protocol}://${public_address}:${real_public_port}/",
    internal_url        => "${internal_protocol}://${internal_address}:${port}/",
    admin_url           => "${admin_protocol}://${admin_address}:${port}/",
  }

}

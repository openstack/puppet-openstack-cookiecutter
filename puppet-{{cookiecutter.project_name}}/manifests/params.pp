# Parameters for puppet-{{cookiecutter.project_name}}
#
class {{cookiecutter.project_name}}::params {

  assert_private()

  include {{cookiecutter.project_name}}::deps
  include openstacklib::defaults

  $group = '{{cookiecutter.project_name}}'

  case $facts['os']['family'] {
    'RedHat': {
    }
    'Debian': {
    }
    default: {
      fail("Unsupported osfamily: ${facts['os']['family']}")
    }

  } # Case $facts['os']['family']
}

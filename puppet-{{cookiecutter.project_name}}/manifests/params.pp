# Parameters for puppet-{{cookiecutter.project_name}}
#
class {{cookiecutter.project_name}}::params {

  assert_private()

  include {{cookiecutter.project_name}}::deps
  include openstacklib::defaults

  $pyvers = $::openstacklib::defaults::pyvers
  $group = '{{cookiecutter.project_name}}'

  case $::osfamily {
    'RedHat': {
    }
    'Debian': {
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, \
module ${module_name} only support osfamily RedHat and Debian")
    }

  } # Case $::osfamily
}

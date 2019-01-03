# Parameters for puppet-{{cookiecutter.project_name}}
#
class {{cookiecutter.project_name}}::params {

  include ::{{cookiecutter.project_name}}::deps
  include ::openstacklib::defaults

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

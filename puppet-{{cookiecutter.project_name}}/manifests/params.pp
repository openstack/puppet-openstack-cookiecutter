# Parameters for puppet-{{cookiecutter.project_name}}
#
class {{cookiecutter.project_name}}::params {

  include ::{{cookiecutter.project_name}}::deps
  include ::openstacklib::defaults

  $pyvers = $::openstacklib::defaults::pyvers
  $group = '{{cookiecutter.project_name}}'

  case $::osfamily {
    'RedHat': {
    }
    'Debian': {
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}

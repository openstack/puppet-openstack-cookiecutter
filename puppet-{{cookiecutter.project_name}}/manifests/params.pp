# Parameters for puppet-{{cookiecutter.project_name}}
#
class {{cookiecutter.project_name}}::params {

  include ::{{cookiecutter.project_name}}::deps

  include ::openstacklib::defaults

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

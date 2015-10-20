# Parameters for puppet-{{cookiecutter.project_name}}
#
class {{cookiecutter.project_name}}::params {

  case $::osfamily {
    'RedHat': {
      $sqlite_package_name  = undef
    }
    'Debian': {
      $sqlite_package_name  = 'python-pysqlite2'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}

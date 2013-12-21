import "master/*.pp"

class munin::master (
  $ensure      = present,
  $autoupgrade = true
) inherits munin::master::params {

  case $ensure {
    /(present)/: {
      $dir_ensure = 'directory'
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'present'
      }
    }
    /(absent)/: {
      $package_ensure = 'absent'
      $dir_ensure = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  include munin::master::install
  include munin::master::config

  case $munin::master::params::http_server {
    'apache': {
      include munin::master::apache
    }
    '': {
    }
    default: {
      fail('ensure http_server must be apache or empty')
    }
  }

}

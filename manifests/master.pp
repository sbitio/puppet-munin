# munin::master
#
# This class is responsible for installing and configuring the munin-master
#
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

  if $munin::master::params::ssh_gen_key {
    exec { 'munin-ssh-keygen' :
      command => 'yes "" | ssh-keygen',
      user    => munin,
      creates => '/var/lib/munin/.ssh/id_rsa',
      require => Package[$munin::master::params::package],
    }
  }

  case $munin::master::params::http_server {
    'apache': {
      include munin::master::apache
    }
    'apache_niteman': {
      include munin::master::apache_niteman
    }
    '': {
    }
    default: {
      fail("unsupported http_server = ${munin::master::params::http_server} param")
    }
  }

}

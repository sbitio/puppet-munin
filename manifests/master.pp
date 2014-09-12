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

  if $ssh_gen_key {
    exec { 'munin-ssh-keygen' :
      command => 'yes "" | ssh-keygen',
      user    => munin,
      creates => '/var/lib/munin/.ssh/id_rsa',
      require => Package[$package],
    }
  }

  case $http_server {
    'apache': {
      include munin::master::apache
    }
    'apache_niteman': {
      include munin::master::apache_niteman
    }
    '': {
    }
    default: {
      fail("unsupported http_server = ${http_server} param")
    }
  }

}

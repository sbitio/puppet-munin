class munin::node (
  $ensure      = present,
  $autoupgrade = true,
  Optional[String] $master_group = undef
) inherits munin::node::params {
  case $ensure {
    /(present)/: {
      $dir_ensure = 'directory'
      $service_ensure = 'running'
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'present'
      }
    }
    /(absent)/: {
      $package_ensure = 'absent'
      $dir_ensure = 'absent'
      $service_ensure = 'stopped'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  class{'munin::node::install': }
  -> class{'munin::node::config': }
  ~> class{'munin::node::service': }
  -> Class['munin::node']

  case $munin::node::params::transport {
    'ssh' : {
      include munin::node::ssh
    }
    default : {}
  }
  $master_node_seed = {
    master        => $munin::node::params::node_master,
    group         => $master_group,
    address       => $::fqdn,
    use_node_name => $munin::node::params::name_in_master ? {
      $::fqdn => false,
      default => true,
    },
    ssh           => $munin::node::params::transport ? {
      'ssh'   => true,
      default => false,
    },
    jump_host => $munin::node::params::jump_host,
  }

  @@munin::master::node { $munin::node::params::name_in_master:
    * => merge($master_node_seed, $munin::node::params::node_defaults),
  }
}

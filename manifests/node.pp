class munin::node (
  $ensure      = present,
  $autoupgrade = true
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

  class{'munin::node::install': } ->
  class{'munin::node::config': } ~>
  class{'munin::node::service': } ->
  Class['munin::node']

  case $transport {
    'ssh' : {
      include munin::node::ssh
    }
    default : {}
  }
  $master_node_seed = {
    master        => $node_master,
    address       => $::fqdn,
    use_node_name => $name_in_master ? {
      $::fqdn => false,
      default => true,
    },
    ssh           => $transport ? {
      'ssh'   => true,
      default => false,
    },
  }

  @@munin::master::node { $name_in_master:
    * => merge($master_node_seed, $node_defaults),
  }
}

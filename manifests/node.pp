import "node/*.pp"

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

  include munin::node::install
  include munin::node::config
  include munin::node::service

  $master_node_seed = {
    master => $node_master,
  }
  # TODO: add stdlib as dependency
  $master_node = {
    "${::fqdn}" => merge($master_node_seed, $node_defaults),
  }
  #notify { "---${master_node}---": }
  create_resources('@@munin::master::node', $master_node)

}

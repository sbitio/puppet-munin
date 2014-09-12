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

  if $master_ssh_key != undef {
    #user { 'munin' :
    #  shell      => '/bin/sh',
    #  managehome => true,
    #  require    => Package['munin-node'],
    #}
    #exec { 'create-munin-home' :
    #  command => 'mkdir -p /var/lib/munin && chmod 755 /var/lib/munin && chown munin:munin /var/lib/munin',
    #  creates => '/var/lib/munin',
    #  require => User['munin'],
    #}
    ssh_authorized_key { "munin@${node_master}" :
      user    => 'munin',
      ensure  => $package_ensure ? {
        absent  => absent,
        default => present,
      },
      type    => 'ssh-rsa',
      key     => $master_ssh_key,
      require => [
        Class['::munin::node::install'],
        Class['::munin::node::config'],
        Class['::munin::node::service'],
      ],
    #  require => Exec['create-munin-home'],
    }
  }

  $master_node_seed = {
    master => $node_master,
    ssh    => $master_ssh_key ? {
      undef   => false,
      default => true,
    },
  }
  # TODO: add stdlib as dependency
  $master_node = {
    "${::fqdn}" => merge($master_node_seed, $node_defaults),
  }
  #notify { "---${master_node}---": }
  create_resources('@@munin::master::node', $master_node)

}

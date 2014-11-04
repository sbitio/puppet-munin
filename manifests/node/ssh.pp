class munin::node::ssh (
  $ensure              = $::munin::node::ensure,
  $node_master         = $::munin::node::node_master,
  $master_ssh_key      = undef,
  $master_ssh_key_type = 'ssh-rsa',
  $munin_home          = '/var/lib/munin',
) {

  user { 'munin' :
    ensure     => $ensure,
    shell      => '/bin/sh',
    home       => $munin_home,
    require    => Package[$::munin::node::package],
  } ->
  file { $munin_home :
    ensure => $ensure ? {
      present => directory,
      default => absent,
    },
    owner => 'munin',
    group => 'munin',
    mode  => 0775,
  } ->
  ssh_authorized_key { "munin@${node_master}" :
    user    => 'munin',
    ensure  => $ensure,
    type    => $master_ssh_key_type,
    key     => $master_ssh_key,
    require => [
      Class['::munin::node::install'],
      Class['::munin::node::config'],
      Class['::munin::node::service'],
    ],
  }

}


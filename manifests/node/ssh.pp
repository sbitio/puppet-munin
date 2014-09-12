class munin::node::ssh (
  $ensure              = $::munin::ensure,
  $node_master         = $::munin::node_master,
  $master_ssh_key      = undef,
  $master_ssh_key_type = 'ssh-rsa',
) {

  user { 'munin' :
    ensure     => $ensure,
    shell      => '/bin/sh',
  #  managehome => true,
    require    => Package[$::munin::node::package],
  }
  #exec { 'create-munin-home' :
  #  command => 'mkdir -p /var/lib/munin && chmod 755 /var/lib/munin && chown munin:munin /var/lib/munin',
  #  creates => '/var/lib/munin',
  #  require => User['munin'],
  #}
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
  #  require => Exec['create-munin-home'],
  }

}

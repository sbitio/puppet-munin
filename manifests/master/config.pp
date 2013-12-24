class munin::master::config () {
  require munin::master::params
  require munin::master::install

  $config_dir     = $munin::master::params::config_dir
  $graph_strategy = $munin::master::params::graph_strategy
# TO-DO: add support for other contact modifiers http://munin-monitoring.org/wiki/munin.conf
  $contact        = $munin::master::params::contact

  file { $munin::master::params::config_file :
    ensure  => $munin::master::ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('munin/master/munin.conf.erb'),
  }

  file { $munin::master::params::config_dir:
    ensure  => $munin::master::dir_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    recurse => true,
    purge   => true,
  }

#  @@munin::master::node { $::fqdn:
#    master  => $::fqdn,
#    address => '127.0.0.1',
#  }
#  @@munin::master::group { 'pruebas':
#    master  => $::fqdn,
#  }

  $defaults = {
    master => $::fqdn,
  }

  create_resources(munin::master::node, hiera_hash('munin::master::nodes',{}), $defaults)
  create_resources(munin::master::group, hiera_hash('munin::master::groups',{}), $defaults)

  Munin::Master::Node <| master == $::fqdn |>
  Munin::Master::Node <<| master == $::fqdn |>>

  Munin::Master::Group <| master == $::fqdn |>
  Munin::Master::Group <<| master == $::fqdn |>>
}

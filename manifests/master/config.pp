class munin::master::config () {
  require munin::master::params
  require munin::master::install

  $config_dir       = $munin::master::params::config_dir
  $graph_strategy   = $munin::master::params::graph_strategy
  $html_strategy    = $munin::master::params::html_strategy
  $rrdcached_socket = $munin::master::params::rrdcached_socket
  # TODO: add support for other contact modifiers http://munin-monitoring.org/wiki/munin.conf
  $contact          = $munin::master::params::contact
  $graph_data_size  = $munin::master::params::graph_data_size
  $htmldir          = $munin::master::params::htmldir

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

  $nodes = hiera_hash('munin::master::nodes', {})
  $nodes.each |String $name, Hash $params| {
    $params_real = merge($params, $defaults)
    munin::master::node { $name:
      * => $params_real,
    }
  }
  $groups = hiera_hash('munin::master::groups', {})
  $groups.each |String $name, Hash $params| {
    $params_real = merge($params, $defaults)
    munin::master::group { $name:
      * => $params_real,
    }
  }

  Munin::Master::Node <| master == $::fqdn |>
  Munin::Master::Node <<| master == $::fqdn |>>

  Munin::Master::Group <| master == $::fqdn |>
  Munin::Master::Group <<| master == $::fqdn |>>
}

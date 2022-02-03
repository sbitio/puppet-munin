class munin::node::config () {
  require munin::node::params
  require munin::node::install

  #TO-DO: Autoconf should happen afterplugin install
  include munin::node::autoconf

  $host       = $munin::node::params::host
  $port       = $munin::node::params::port
  $allow      = $munin::node::params::allow
  $cidr_allow = $munin::node::params::cidr_allow
  $cidr_deny  = $munin::node::params::cidr_deny

  $log_file   = $munin::node::params::log_file

  file { $munin::node::params::config_file :
    ensure  => $munin::node::ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('munin/node/munin-node.conf.erb'),
    notify  => Service[$munin::node::params::service_name],
  }

  file { $munin::node::params::plugin_dir:
    ensure  => $munin::node::dir_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $munin::node::params::plugin_conf_dir:
    ensure  => $munin::node::dir_ensure,
    owner   => 'root',
    group   => 'munin',
    mode    => '0640',
    recurse => true,
    purge   => true,
    notify  => Service[$munin::node::params::service_name],
  }

  file { "${munin::node::params::plugin_conf_dir}/00_defaults":
    ensure  => $munin::node::ensure,
    owner   => 'root',
    group   => 'munin',
    mode    => '0640',
    source  => $munin::node::params::plugin_conf_src,
    notify  => Service[$munin::node::params::service_name],
  }

  file { $munin::node::params::scripts_dir:
    ensure  => $munin::node::dir_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $munin::node::params::imported_scripts_dir:
    ensure  => $munin::node::dir_ensure,
    owner   => 'root',
    group   => 'munin',
    mode    => '0644',
    recurse => true,
    purge   => true,
  }

#  @@munin::node::plugin { 'munin-node':
#    tag => $::fqdn,
#  }

  $plugins = hiera_hash('munin::node::plugins', {})
  $plugins.each |String $name, Hash $params| {
    munin::node::plugin { $name:
      * => $params,
    }
  }

  Munin::Node::Plugin <| |>
  Munin::Node::Plugin <<| tag == $::fqdn |>>

  Munin::Node::Plugin::Conf <| |>
  Munin::Node::Plugin::Conf <<| tag == $::fqdn |>>

}

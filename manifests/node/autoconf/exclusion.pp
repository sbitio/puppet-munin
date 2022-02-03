define munin::node::autoconf::exclusion () {

  require munin::node::params

  if $munin::node::params::autoconf {

    concat::fragment { "munin_node_autoconf_excl-${name}" :
      target  => 'munin_node_autoconf_excl',
      content => "\\@${::munin::node::params::plugin_dir}/${name}@d\n",
    }

  }

}

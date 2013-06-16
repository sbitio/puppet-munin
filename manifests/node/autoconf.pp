class munin::node::autoconf () {

  require munin::node::params

  exec {"munin-node-configure":
    #refreshonly => true,
    command     => "munin-node-configure --shell | sh",
    unless      => "[ $(munin-node-configure --shell 2> /dev/null | wc -l) = 0 ]",
    path        => ["/usr/bin", "/usr/sbin", "/bin"],
    notify      => Service[$munin::node::params::service_name],
  }

}
class munin::node::service () {
  require munin::node::params
  require munin::node::install
  require munin::node::config

  service { $munin::node::params::service_name:
    ensure     => $munin::node::service_ensure,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
  }
}
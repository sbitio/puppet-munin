class munin::node::install () {
  require munin::node::params
  
  if ( $::lsbdistcodename == 'squeeze' ) {
    apt::force { $munin::node::params::package:
      release => "squeeze-backports",
      require => Apt::Source["backports"],
    }
  }

  package { $munin::node::params::package:
    ensure => $munin::node::package_ensure,
  }
}

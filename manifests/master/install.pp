class munin::master::install () {
  require munin::master::params
  
  apt::force { $munin::master::params::package:
    release => "squeeze-backports",
    require => Apt::Source["backports"],
  }

  package { $munin::master::params::package:
    ensure => $munin::master::package_ensure,
  }
}

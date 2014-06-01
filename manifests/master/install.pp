class munin::master::install () {
  require munin::master::params
  
  if ( $::lsbdistcodename == 'squeeze' ) {
    apt::force { $munin::master::params::package:
      release => "squeeze-backports",
      require => Apt::Source["backports"],
    }
  }
  if ( $::lsbdistcodename == 'wheezy' ) {
    apt::force { $munin::master::params::package:
      release => "wheezy-backports",
      require => Apt::Source["backports"],
    }
  }

  package { $munin::master::params::package:
    ensure => $munin::master::package_ensure,
  }
}

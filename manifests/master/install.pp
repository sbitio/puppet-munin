class munin::master::install () {
  require munin::master::params
  
  package { $munin::master::params::package:
    ensure          => $munin::master::package_ensure,
    install_options => $::lsbdistcodename ? {
      /(squeeze|wheezy)/ => ['-t', "${::lsbdistcodename}-backports"],
      default            => undef,
    },
    require         => $::lsbdistcodename ? {
      /(squeeze|wheezy)/ => Apt::Source["backports"],
      default            => undef,
    }
  }
}

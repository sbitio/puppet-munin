class munin::node::install () {
  require munin::node::params
  
  package { $munin::node::params::package:
    ensure          => $munin::node::package_ensure,
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

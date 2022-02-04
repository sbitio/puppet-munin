class munin::node::install () {
  require munin::node::params

  $_real_install_options = $::lsbdistcodename ? {
    /(squeeze|wheezy)/ => ['-t', "${::lsbdistcodename}-backports"],
    default            => undef,
  }

  $_real_require = $::lsbdistcodename ? {
    /(squeeze|wheezy)/ => Apt::Source['backports'],
    default            => undef,
  }

  package { $munin::node::params::package:
    ensure          => $munin::node::package_ensure,
    install_options => $_real_install_options,
    require         => $_real_require
  }
}

# munin::master::install
#
# This class handles the installation of the munin-master package
#
class munin::master::install () {
  require munin::master::params

  $_real_install_options = $::lsbdistcodename ? {
    /(squeeze|wheezy)/ => ['-t', "${::lsbdistcodename}-backports"],
    default            => undef,
  }

  $_real_require = $::lsbdistcodename ? {
    /(squeeze|wheezy)/ => Apt::Source['backports'],
    default            => undef,
  }

  package { $munin::master::params::package:
    ensure          => $munin::master::package_ensure,
    install_options => $_real_install_options,
    require         => $_real_require
  }
}

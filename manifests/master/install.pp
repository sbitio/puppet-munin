# munin::master::install
#
# This class handles the installation of the munin-master package
#
class munin::master::install () {
  require munin::master::params

  $_real_install_options = $facts['os']['distro']['codename'] ? {
    /(squeeze|wheezy)/ => ['-t', "${facts['os']['distro']['codename']}-backports"],
    default            => undef,
  }

  $_real_require = $facts['os']['distro']['codename'] ? {
    /(squeeze|wheezy)/ => Apt::Source['backports'],
    default            => undef,
  }

  package { $munin::master::params::package:
    ensure          => $munin::master::package_ensure,
    install_options => $_real_install_options,
    require         => $_real_require
  }
}

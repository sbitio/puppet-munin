# munin::node::install
#
# This class handles the installation of the munin-node package
#
class munin::node::install () {
  require munin::node::params

  $_real_install_options = $facts['os']['distro']['codename'] ? {
    /(squeeze|wheezy)/ => ['-t', "${facts['os']['distro']['codename']}-backports"],
    default            => undef,
  }

  $_real_require = $facts['os']['distro']['codename'] ? {
    /(squeeze|wheezy)/ => Apt::Source['backports'],
    default            => undef,
  }

  package { $munin::node::params::package:
    ensure          => $munin::node::package_ensure,
    install_options => $_real_install_options,
    require         => $_real_require
  }
}

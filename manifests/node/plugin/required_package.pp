# munin::node::plugin::required_package
#
# This defined type handles the installation of plugin required packages
#
define munin::node::plugin::required_package (
  $ensure = present,
) {

  case $ensure {
    present: {
      ensure_packages(any2array($name))
    }
    absent: {
      if ! defined(Package[$name]) {
        package { $name :
          ensure => $ensure,
        }
      }
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }
}

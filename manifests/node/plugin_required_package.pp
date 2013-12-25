define munin::node::plugin::required_package (
  $ensure = present,
) {

  case $ensure {
    present : {
      # TODO: add stdlib as dependency
      ensure_packages(any2array($name))
    }
    absent  : {
      if ! defined(Package[$name]) {
        package { $name :
          ensure => $ensure,
        }
      }
    }
  }
}

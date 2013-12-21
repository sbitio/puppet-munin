define munin::node::plugin::required_package (
  $ensure            = present,
) {

  if ! defined(Package[$name]) {
    package { $name :
      ensure => $ensure,
    }
  }
}

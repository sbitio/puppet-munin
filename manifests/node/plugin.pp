define munin::node::plugin (
  $ensure            = present,
  $group             = $name,
  $sufixes           = [],
  $config            = {},
  $source            = '',
  $content           = '',
  $required_packages = [],
) {

  require munin::node::params

  if $source != '' or $content != '' {
    $plugin_file = "${munin::node::params::imported_scripts_dir}/${name}"
    file { $plugin_file:
      ensure => $ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => $source ? {
        ''      => undef,
        default => $source,
      },
      content => $content ? {
        ''      => undef,
        default => $content,
      },
    }
  }
  else {
    $plugin_file = "${munin::node::params::scripts_dir}/${name}"
  }

  # Can't use a selector until http://projects.puppetlabs.com/issues/5860 is fixed
  #$file_links = $sufixes ? {
  #  []      => "${munin::node::params::plugin_dir}/${name}",
  #  default => prefix($sufixes, "${munin::node::params::plugin_dir}/${name}"),
  #}
  if $sufixes == [] {
    $file_links = "${munin::node::params::plugin_dir}/${name}"
  }
  else {
    $file_links = prefix($sufixes, "${munin::node::params::plugin_dir}/${name}")
  }

  # Ensure dependant packages installed
  case $ensure {
    present : {
      munin::node::plugin::package_helper { $required_packages :
        ensure => $ensure,
        before => File[$file_links],
      }
    }
  }

  file { $file_links :
    ensure => $ensure ? {
      present => link,
      default => $ensure,
    },
    target => $plugin_file,
    notify => Service[$munin::node::service_name],
  }
}

define munin::node::plugin::package_helper (
  $package = $title,
  $ensure  = $munin::node::plugin::ensure,
) {
  if !defined(Package[$package]) {
    package { $package :
      ensure => $ensure
    }
  }
}

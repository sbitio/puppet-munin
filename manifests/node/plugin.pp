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
    # TODO: add stdlib dependency
    $file_links = prefix($sufixes, "${munin::node::params::plugin_dir}/${name}")
  }

  create_resources(munin::node::plugin::conf, $config, {})
  $config_keys = keys($config)

  file { $file_links :
    ensure  => $ensure ? {
      present => link,
      default => $ensure,
    },
    target  => $plugin_file,
    require => Munin::Node::Plugin::Conf[$config_keys],
    notify  => Service[$munin::node::params::service_name],
  }
}

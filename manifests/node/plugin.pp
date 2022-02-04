# munin::node::plugin
#
# This defined type is responsible for managing the munin-node plugins
#
define munin::node::plugin (
  $ensure            = present,
  $sufixes           = [],
  $config            = [],
  $source            = '',
  $content           = '',
  $target            = '',
  $required_packages = [],
) {

  require munin::node::params

  $_real_plugin_file_target = $target ? {
    ''      => $ensure,
    default => link,
  }

  $_real_plugin_file_ensure = $ensure ? {
    present => $_real_plugin_file_target,
    default => $ensure,
  }

  $_real_source = $source ? {
    ''      => undef,
    default => $source,
  }

  $_real_target = $target ? {
    ''      => undef,
    default => $target,
  }

  $_real_content = $content ? {
    ''      => undef,
    default => $content,
  }

  $_real_file_links_ensure = $ensure ? {
    present => link,
    default => $ensure,
  }

  if $source != '' or $content != '' or $target != '' {
    #TODO# ensure only one of $source,$content,$target is defined
    $plugin_file = "${munin::node::params::imported_scripts_dir}/${name}"
    file { $plugin_file:
      ensure  => $_real_plugin_file_ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      source  => $_real_source,
      target  => $_real_target,
      content => $_real_content,
      notify  => Service[$munin::node::params::service_name],
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

  if $config != [] {
    if $sufixes != [] {
      $conf = {
        "${name}*" => $config,
      }
    }
    else {
      $conf = {
        "${name}" => $config,
      }
    }
    munin::node::plugin::conf { $name:
      config => $conf,
    }
  }

  Munin::Node::Plugin::Required_package <| tag == $name |> {
    before => File[$file_links],
  }

  file { $file_links :
    ensure => $_real_file_links_ensure,
    target => $plugin_file,
    notify => Service[$munin::node::params::service_name],
  }
}

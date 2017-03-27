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

  if $source != '' or $content != '' or $target != '' {
    #TODO# ensure only one of $source,$content,$target is defined
    $plugin_file = "${munin::node::params::imported_scripts_dir}/${name}"
    file { $plugin_file:
      ensure => $ensure ? {
        present => $target ? {
          ''      => $ensure,
          default => link,
        },
        default => $ensure,
      },
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      source  => $source ? {
        ''      => undef,
        default => $source,
      },
      target  => $target ? {
        ''      => undef,
        default => $target,
      },
      content => $content ? {
        ''      => undef,
        default => $content,
      },
      notify => Service[$munin::node::params::service_name],
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
    if $sufixex != [] {
      $conf = {
        "${name}*" => $config,
      }
    }
    else {
      $conf = {
        "${name}" => $config,
      }
    }
    $plugin_conf = {
      "${name}" => {
        config => $conf,
      },
    }
  }
  else {
    $plugin_conf = {}
  }
  create_resources(munin::node::plugin::conf, $plugin_conf, {})

  Munin::Node::Plugin::Required_package <| tag == $name |> {
    before => File[$file_links],
  }

  file { $file_links :
    ensure  => $ensure ? {
      present => link,
      default => $ensure,
    },
    target  => $plugin_file,
    notify  => Service[$munin::node::params::service_name],
  }
}

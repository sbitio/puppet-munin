define munin::node::plugin (
  $ensure  = present,
  $group   = $name,
  $sufixes = [],
  $config  = {},
  $source  = '',
  $content = '',
) {

  require munin::node::params

  if $source != '' or content != '' {
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


  #link_dst?
  
}

define munin::node::plugin::conf (
  $ensure            = present,
  $config            = {},
  $source            = '',
  $content           = '',
) {

  require munin::node::params

  $conf_file = "${munin::node::params::plugin_conf_dir}/${name}"

  file { $plugin_file:
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => $source ? {
      ''      => undef,
      default => $source,
    },
    content => $content ? {
      ''      => template('munin/node/plugin_conf.erb'),
      default => $content,
    },
  }

}

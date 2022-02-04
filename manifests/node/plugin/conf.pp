define munin::node::plugin::conf (
  $ensure            = present,
  $config            = {},
  $source            = '',
  $content           = '',
) {

  require munin::node::params

  $conf_file = "${munin::node::params::plugin_conf_dir}/${name}"

  $_real_source = $source ? {
    ''      => undef,
    default => $source,
  }

  $_real_content = $content ? {
    ''      => template('munin/node/plugin_conf.erb'),
    default => $content,
  }

  file { $conf_file:
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => $_real_source,
    content => $_real_content,
    notify  => Service[$munin::node::params::service_name],
  }

}

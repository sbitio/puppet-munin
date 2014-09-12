define munin::master::node (
  $master,
  $address       = $title,
  $ensure        = $munin::master::ensure,
  $group         = '',
  $use_node_name = false,
  $update        = true,
  $contacts      = '',
  $extra_configs = [],
  $port          = 4949,
  $ssh           = false,
) {
  require munin::master::params

  validate_bool($ssh)

  $full_name = $group ? {
    ''      => $name,
    default => "${name}.${group}",
  }
  $header    = $group ? {
    ''      => $name,
    default => "${group};${name}",
  }

  file { "${munin::master::params::config_dir}/${full_name}.conf" :
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('munin/master/node.conf.erb'),
  }
}

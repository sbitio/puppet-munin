define munin::master::group (
  $master,
  $ensure        = $munin::master::ensure,
  $local_address = undef,
  $node_order    = '',
  $contacts       = '',
) {
  file { "${munin::master::params::config_dir}/${name}_group.conf" :
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('munin/master/group.conf.erb'),
  }
}
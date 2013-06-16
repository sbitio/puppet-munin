class munin::node::params (
  $autoconf   = true,
  $host       = '*',
  $port       = 4949,
  $allow      = '^127\.0\.0\.1$',
  $cidr_allow = '',
  $cidr_deny  = '',
) {
  case $::operatingsystem {
    ubuntu, debian: {
      $package         = 'munin-node'
      $service_name    = 'munin-node'
      $config_file     = '/etc/munin/munin-node.conf'
      $plugin_dir      = '/etc/munin/plugins'
      $plugin_conf_dir = '/etc/munin/plugin-conf.d'
      $scripts_dir     = '/usr/share/munin/plugins'
      $plugin_conf_src = 'puppet:///modules/munin/node/plugin-conf-default.debian'
    }
#    redhat, centos: {
#    }
    default: {
      fail("Unsupported platform: ${::operatingsystem}")
    }
  }

  $imported_scripts_dir = "${scripts_dir}/puppet-imported"

}

class munin::node::params (
  $autoconf       = true,
  $host           = '*',
  $port           = 4949,
  $allow          = [
    '^127\.0\.0\.1$',
    '^::1$',
  ],
  $cidr_allow     = [],
  $cidr_deny      = [],
  $node_master    = $::fqdn,
  $node_defaults  = {},
  $transport      = undef,
  $jump_host      = undef,
  $name_in_master = $::fqdn,
) {

  case $::osfamily {
    'Debian': {
      case $::lsbmajdistrelease {
        '7': {
          $package = [
            'munin-node',
            'munin-plugins-core',
            'munin-plugins-extra',
          ]
        }
        default: {
          $package = [
            'munin-node',
            'munin-plugins-core',
            'munin-plugins-extra',
            'netcat',
          ]
        }
      }
      $log_file = '/var/log/munin/munin-node.log'
    }
    'RedHat': {
      $package = [
        'munin-node',
      ]
      $log_file = '/var/log/munin-node/munin-node.log'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily Debian and RedHat")
    }
  }

  $service_name         = 'munin-node'
  $pidfile              = '/var/run/munin/munin-node.pid'
  $config_file          = '/etc/munin/munin-node.conf'
  $plugin_dir           = '/etc/munin/plugins'
  $plugin_conf_dir      = '/etc/munin/plugin-conf.d'
  $scripts_dir          = '/usr/share/munin/plugins'
  # TODO
  $plugin_conf_src      = "puppet:///modules/munin/node/plugin-conf-default.${::osfamily}"
  $imported_scripts_dir = "${scripts_dir}/puppet-imported"
}

# munin::master::params
#
# This class handles the data for the master side of the module
#
class munin::master::params (
  $contact          = {
    'root' => 'mail -s "Munin notification for ${var:group}::${var:host}" root',
  },
  $http_server      = 'apache',
  $http_name        = "munin.${facts['networking']['fqdn']}",
  $graph_strategy   = 'cgi',
  $graph_data_size  = 'normal',
  $html_strategy    = 'cron',
  $rrdcached_socket = undef,
  $ssh_gen_key      = true,
) {

  $uses_cgi       = ( $graph_strategy == 'cgi' or $html_strategy == 'cgi' )
  $package        = $facts['os']['family'] ? {
    debian => 'munin',
    redhat => $uses_cgi ? {
      true    => $http_server ? {
        apache  => [ 'munin', 'munin-cgi' ],
        nginx   => [ 'munin', 'munin-nginx' ],
        default => 'munin',
      },
      default => 'munin',
    },
  }
  $config_file    = '/etc/munin/munin.conf'
  $config_dir     = $facts['os']['family'] ? {
    debian => '/etc/munin/munin-conf.d',
    redhat => '/etc/munin/conf.d',
  }
  $htmldir        = $facts['os']['family'] ? {
    debian => '/var/cache/munin/www',
    redhat => '/var/www/html/munin',
  }
  $cgi_graph_path = $facts['os']['family'] ? {
    debian => '/usr/lib/munin/cgi/munin-cgi-graph',
    redhat => '/var/www/cgi-bin/munin-cgi-graph',
  }
  $cgi_html_path  = $facts['os']['family'] ? {
    debian => '/usr/lib/munin/cgi/munin-cgi-html',
    redhat => '/var/www/cgi-bin/munin-cgi-html',
  }

  case $facts['os']['family'] {
    debian, redhat: { }
    default: {
      fail("Unsupported platform: ${facts['os']['family']}")
    }
  }

}

class munin::master::params (
  $contact          = {
    'root' => 'mail -s "Munin notification for ${var:group}::${var:host}" root',
  },
  $http_server      = 'apache',
  $http_name        = "munin.${::fqdn}",
  $graph_strategy   = 'cgi',
  $graph_data_size  = 'normal',
  $html_strategy    = 'cron',
  $rrdcached_socket = undef,
  $ssh_gen_key      = true,
) {

  $uses_cgi       = ( $graph_strategy == 'cgi' or $html_strategy == 'cgi' )
  $package        = $::osfamily ? {
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
  $config_dir     = $::osfamily ? {
    debian => '/etc/munin/munin-conf.d',
    redhat => '/etc/munin/conf.d',
  }
  $htmldir        = $::osfamily ? {
    debian => '/var/cache/munin/www',
    redhat => '/var/www/html/munin',
  }
  $cgi_graph_path = $::osfamily ? {
    debian => '/usr/lib/munin/cgi/munin-cgi-graph',
    redhat => '/var/www/cgi-bin/munin-cgi-graph',
  }
  $cgi_html_path  = $::osfamily ? {
    debian => '/usr/lib/munin/cgi/munin-cgi-html',
    redhat => '/var/www/cgi-bin/munin-cgi-html',
  }

  case $::osfamily {
    debian, redhat: { }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }

}

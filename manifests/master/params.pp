class munin::master::params (
  $contact          = {
    'root' => 'mail -s "Munin notification for ${var:group}::${var:host}" root',
  },
  $http_server      = 'apache',
  $http_name        = "munin.${fqdn}",
  $graph_strategy   = 'cgi',
  $graph_data_size  = 'normal',
  $html_strategy    = undef,
  $rrdcached_socket = undef,
) {

  $package     = 'munin'
  $config_file = '/etc/munin/munin.conf'

  $config_dir  = $::osfamily ? {
    debian => '/etc/munin/munin-conf.d',
    redhat => '/etc/munin/conf.d',
  }
  $htmldir     = $::osfamily ? {
    debian => '/var/cache/munin/www',
    redhat => '/var/www/html/munin',
  }

  case $::osfamily {
    debian, redhat: { }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }

}

class munin::master::params (
  $contact         = {
    'root' => 'mail -s "Munin notification for ${var:group}::${var:host}" root',
  },
  $http_server     = 'apache',
  $http_name       = "munin.${fqdn}",
  $graph_strategy  = 'cgi',
  $graph_data_size = 'normal',
) {
  case $::operatingsystem {
    ubuntu, debian: {
      $package     = 'munin'
      $config_file = '/etc/munin/munin.conf'
      $config_dir  = '/etc/munin/munin-conf.d'
      $htmldir     = '/var/cache/munin/www'
    }
#    redhat, centos: {
#    }
    default: {
      fail("Unsupported platform: ${::operatingsystem}")
    }
  }

}

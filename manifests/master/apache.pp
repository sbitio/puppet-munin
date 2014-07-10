class munin::master::apache (
  $ensure = $munin::master::ensure,
) {
  require munin::master::params

  if defined(Class['apache']) {
    if !defined(Apache::Module['fcgi']) {
      @apache::module { 'fcgid':
        ensure  => $ensure,
        package => 'libapache2-mod-fcgid',
      }
    }
    @apache::vhost { $munin::master::params::http_name:
      ensure           => $ensure,
# TO-DO: better suport of ip tagging
      tag              => 'munin',
      priority         => '020',
#      server_aliases   => '192.168.8.90',
      ssl_ports        => [],
      doc_root         => $munin::master::params::htmldir,
      dir_options      => 'None',
      dir_directives   => [
        'Allow from all',
        '<IfModule mod_expires.c>',
        '  ExpiresActive On',
        '  ExpiresDefault M310',
        '</IfModule>',
      ],
      vhost_directives => [
        '# Ensure we can run (fast)cgi scripts',
        'ScriptAlias /munin-cgi/munin-cgi-graph /usr/lib/munin/cgi/munin-cgi-graph',
        '<Location /munin-cgi/munin-cgi-graph>',
        '  Options +ExecCGI',
        '  <IfModule mod_fcgid.c>',
        '      SetHandler fcgid-script',
        '  </IfModule>',
        '  <IfModule !mod_fcgid.c>',
        '      SetHandler cgi-script',
        '  </IfModule>',
        '  Allow from all',
        '</Location>',
        'ScriptAlias /munin-cgi/munin-cgi-html /usr/lib/munin/cgi/munin-cgi-html',
        '<Location /munin-cgi/munin-cgi-html>',
        '  <IfModule mod_fcgid.c>',
        '      SetHandler fcgid-script',
        '  </IfModule>',
        '  <IfModule !mod_fcgid.c>',
        '      SetHandler cgi-script',
        '  </IfModule>',
        '</Location>',
      ],

    }
  }
}

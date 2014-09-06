class munin::master::apache (
  $ensure  = $munin::master::ensure,
  $enabled = true,
) {

  if $caller_module_name != $module_name {
    warning("${name} is not part of the public API of the ${module_name} module and should not be directly included in the manifest.")
  }

  if $enabled and defined('::apache') {
    #if !defined(Apache::Module['fcgi']) {
    #  @apache::module { 'fcgid':
    #    ensure  => $ensure,
    #    package => 'libapache2-mod-fcgid',
    #  }
    #}
    #@apache::vhost { $munin::master::params::http_name:
    #  ensure           => $ensure,
# TO#-DO: better suport of ip tagging
    #  tag              => 'munin',
    #  priority         => '020',
#   #   server_aliases   => '192.168.8.90',
    #  ssl_ports        => [],
    #  doc_root         => $munin::master::params::htmldir,
    #  dir_options      => 'None',
    #  dir_directives   => [
    #    'Allow from all',
    #    '<IfModule mod_expires.c>',
    #    '  ExpiresActive On',
    #    '  ExpiresDefault M310',
    #    '</IfModule>',
    #  ],
    #  vhost_directives => [
    #    '# Ensure we can run (fast)cgi scripts',
    #    'ScriptAlias /munin-cgi/munin-cgi-graph /usr/lib/munin/cgi/munin-cgi-graph',
    #    '<Location /munin-cgi/munin-cgi-graph>',
    #    '  Options +ExecCGI',
    #    '  <IfModule mod_fcgid.c>',
    #    '      SetHandler fcgid-script',
    #    '  </IfModule>',
    #    '  <IfModule !mod_fcgid.c>',
    #    '      SetHandler cgi-script',
    #    '  </IfModule>',
    #    '  Allow from all',
    #    '</Location>',
    #    'ScriptAlias /munin-cgi/munin-cgi-html /usr/lib/munin/cgi/munin-cgi-html',
    #    '<Location /munin-cgi/munin-cgi-html>',
    #    '  <IfModule mod_fcgid.c>',
    #    '      SetHandler fcgid-script',
    #    '  </IfModule>',
    #    '  <IfModule !mod_fcgid.c>',
    #    '      SetHandler cgi-script',
    #    '  </IfModule>',
    #    '</Location>',
    #    '<IfModule !mod_rewrite.c>',
    #    '    # required because we serve out of the cgi directory and URLs are relative',
    #    '    Alias /munin-cgi/munin-cgi-html/static /var/cache/munin/www/static',
    #    '    RedirectMatch ^/$ /munin-cgi/munin-cgi-html/',
    #    '</IfModule>',
    #    '<IfModule mod_rewrite.c>',
    #    '    # Rewrite rules to serve traffic from the root instead of /munin-cgi',
    #    '    RewriteEngine On',
    #    '    # Static files',
    #    '    RewriteRule ^/favicon.ico /var/cache/munin/www/static/favicon.ico [L]',
    #    '    RewriteRule ^/static/(.*) /var/cache/munin/www/static/$1          [L]',
    #    '    # HTML',
    #    '    RewriteRule ^(/.*\.html)?$           /munin-cgi/munin-cgi-html/$1 [PT]',
    #    '    # Images',
    #    '    RewriteRule ^/munin-cgi/munin-cgi-graph/(.*) /$1',
    #    '    RewriteCond %{REQUEST_URI}                 !^/static',
    #    '    RewriteRule ^/(.*.png)$  /munin-cgi/munin-cgi-graph/$1 [L,PT]',
    #    '</IfModule>',
    #    '<IfModule !mod_rewrite.c>',
    #    '    <Location /munin-cgi/munin-cgi-html/static>',
    #    '            # this needs to be at the end to override the above sethandler directives',
    #    '            Options -ExecCGI',
    #    '            SetHandler None',
    #    '    </Location>',
    #    '</IfModule>',
    #  ],
    #}
  }
}

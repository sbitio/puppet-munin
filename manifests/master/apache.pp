class munin::master::apache (
  $ensure  = $munin::master::ensure,
  $enabled = true,
  $port    = '80',
) {

  if $caller_module_name != $module_name {
    warning("${name} is not part of the public API of the ${module_name} module and should not be directly included in the manifest.")
  }

  if $enabled and defined('::apache') {
    require ::apache
    if $ensure == 'present' {
      require ::apache::mod::fcgid
    }

    apache::vhost { $::munin::master::http_name :
      ensure         => $ensure,
      priority       => '40',
      port           => $port,
      docroot        => $::munin::master::htmldir,
      manage_docroot => false,
      directories    => [
        { 
          path            => $::munin::master::htmldir,
          override        => [ 'All' ],
          options         => [ 'None' ],
          custom_fragment => '
            <IfModule mod_expires.c>
              ExpiresActive On
              ExpiresDefault M310
            </IfModule>',
        },
        {
          path            => '/munin-cgi/munin-cgi-graph',
          provider        => 'location',
          options         => [ '+ExecCGI' ],
          custom_fragment => '
            <IfModule mod_fcgid.c>
                SetHandler fcgid-script
            </IfModule>
            <IfModule !mod_fcgid.c>
                SetHandler cgi-script
            </IfModule>',
        },
        {
          path            => '/munin-cgi/munin-cgi-html',
          provider        => 'location',
          options         => [ '+ExecCGI' ],
          custom_fragment => '
            <IfModule mod_fcgid.c>
                SetHandler fcgid-script
            </IfModule>
            <IfModule !mod_fcgid.c>
                SetHandler cgi-script
            </IfModule>',
        },
      ],
      scriptaliases  => [
        { 
          alias => '/munin-cgi/munin-cgi-graph',
          path  => $::munin::master::cgi_graph_path,
        },
        { 
          alias => '/munin-cgi/munin-cgi-html',
          path  => $::munin::master::cgi_html_path,
        },
      ],
      rewrites       => [
        {
          comment      => 'Favicon',
          rewrite_rule => "^/favicon.ico ${::munin::master::htmldir}/static/favicon.ico [L]",
        },
        {
          comment      => 'Static files',
          rewrite_rule => "^/static/(.*) ${::munin::master::htmldir}/static/\$1 [L]",
        },
        {
          comment      => 'HTML',
          rewrite_rule => '^(/.*\.html)?$ /munin-cgi/munin-cgi-html/$1 [PT]',
        },
        {
          comment      => 'Images1',
          rewrite_rule => '^/munin-cgi/munin-cgi-graph/(.*) /$1',
        },
        {
          comment      => 'Images2',
          rewrite_cond => '%{REQUEST_URI} !^/static',
          rewrite_rule => '^/(.*.png)$  /munin-cgi/munin-cgi-graph/$1 [L,PT]',
        },
      ],
      # TODO : better suport of ip tagging
      tag            => 'munin',
    }

  }
}

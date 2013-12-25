class munin::node::autoconf (
  $avoid = [],
) {

  require munin::node::params

  if $avoid = [] {
    $filter = ''
  }
  else {
    $filter = inline_template('<% avoid.each do |item| %>| sed "\@<%= item %>@d"<% end%>')
  }

  exec {"munin-node-configure":
    #refreshonly => true,
    command     => "munin-node-configure --shell ${filter} | sh",
    unless      => "[ $(munin-node-configure --shell ${filter} 2> /dev/null | wc -l) = 0 ]",
    path        => ["/usr/bin", "/usr/sbin", "/bin"],
    notify      => Service[$munin::node::params::service_name],
  }

}

# munin
#
# This class is responsible for installing and configuring the munin service.
# Depending whether the host is a munin-master or simply a node, it calls
# the corresponding class to perform the installation and configuration
#
class munin {
  include munin::master
  include munin::node
}

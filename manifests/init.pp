import "*/*.pp"

class munin {
  include munin::master
  include munin::node
}

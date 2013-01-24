class daemontools {
  package { ['daemontools', 'daemontools-run']:
    ensure => 'installed'
  }
}

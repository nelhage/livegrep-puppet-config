class codesearch::monitoring {
  package { ['munin-node', 'munin-plugins-extra']:
    ensure => 'installed'
  }

  file { '/etc/munin/munin-node.conf':
    source => 'puppet:///modules/codesearch/munin-node.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service['munin-node']
  }

  service { 'munin-node':
    ensure  => 'running',
    require => Package['munin-node']
  }
}

class codesearch::monitoring {
  package { ['munin-node', 'munin-plugins-extra']:
    ensure => 'installed'
  }

  file { '/etc/munin':
    source  => 'puppet:///modules/codesearch/munin/',
    recurse => 'true',
    purge   => false,
    owner   => 'munin',
    group   => 'munin',
    notify  => Service['munin-node']
  }

  service { 'munin-node':
    ensure  => 'running',
    require => Package['munin-node']
  }
}

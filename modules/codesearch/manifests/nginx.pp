class codesearch::nginx {
  package { ['nginx', 'varnish']:
    ensure => installed
  }

  file { '/etc/nginx/sites-available/codesearch':
    source  => 'puppet:///modules/codesearch/nginx.conf',
    mode    => 0644,
    owner   => 'root',
    group   => 'root',
    notify  => Service['nginx'],
    require => Package['nginx']
  }

  file { '/etc/nginx/sites-enabled/codesearch':
    ensure  => 'symlink',
    target  => '../sites-available/codesearch',
    notify  => Service['nginx'],
    require => Package['nginx']
  }

  file { '/etc/nginx/sites-enabled/default':
    ensure  => absent,
  }

  service { 'nginx':
    ensure  => 'running',
    require => Package['nginx']
  }

  file { '/etc/varnish/default.vcl':
    source  => 'puppet:///modules/codesearch/default.vcl',
    mode    => 0644,
    owner   => 'root',
    group   => 'root',
    notify  => Service['varnish'],
    require => Package['varnish']
  }

  file { '/etc/default/varnish':
    source  => 'puppet:///modules/codesearch/varnish',
    mode    => 0644,
    owner   => 'root',
    group   => 'root',
    notify  => Service['varnish'],
    require => Package['varnish']
  }

  service { 'varnish':
    ensure  => 'running',
    require => Package['varnish']
  }
}

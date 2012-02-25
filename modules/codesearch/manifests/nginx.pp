class codesearch::nginx {
  package { 'nginx':
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

  service { 'nginx':
    ensure  => 'running',
    require => Package['nginx']
  }
}

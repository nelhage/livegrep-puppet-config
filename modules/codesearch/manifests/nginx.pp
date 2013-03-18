class codesearch::nginx {
  apt::source { 'nginx':
    location => "http://nginx.org/packages/ubuntu/",
    repos    => "nginx",
    key      => "573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62",
    ensure   => 'absent'
  }

  package { 'nginx':
    ensure => installed
  }

  package { 'varnish':
    ensure => absent
  }

  file { '/etc/nginx/sites-available/codesearch':
    source  => 'puppet:///modules/codesearch/nginx.conf',
    mode    => 0644,
    owner   => 'root',
    group   => 'root',
    notify  => Service['nginx'],
    require => Package['nginx']
  }

  file { '/etc/nginx/conf.d/codesearch.conf':
    ensure  => 'symlink',
    target  => '../sites-available/codesearch',
    notify  => Service['nginx'],
    require => Package['nginx']
  }

  file { '/etc/nginx/conf.d/default':
    ensure  => absent,
  }

  service { 'nginx':
    ensure  => 'running',
    require => Package['nginx']
  }
}

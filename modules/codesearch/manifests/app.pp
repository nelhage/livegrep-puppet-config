class codesearch::app {
  file { '/home/nelhage/linux':
    ensure => 'directory',
    owner  => 'nelhage',
    group  => 'nelhage',
  }

  $idx_url = "https://s3.amazonaws.com/livegrep/codesearch.idx"
  exec { "codesearch.idx":
    command => "wget -N ${idx_url}",
    cwd     => "/home/nelhage/linux/",
    creates => "/home/nelhage/linux/codesearch.idx",
    require => File['/home/nelhage/linux'],
    user    => 'nelhage',
    path    => '/usr/bin:/bin'
  }

  file { '/home/nelhage/build-all':
    source => 'puppet:///modules/codesearch/build-all',
    owner  => 'nelhage',
    group  => 'nelhage',
    mode   => 0755
  }

  file { '/mnt/log':
    ensure => 'directory',
    owner  => 'nelhage',
    group  => 'nelhage',
    mode   => 0755
  }

  codesearch::thirdparty::checkout { '/home/nelhage/codesearch':
    source   => "git@nelhage.com:codesearch",
    revision => 'origin/master'
  }
  file { '/home/nelhage/codesearch/Makefile.config':
    source   => "puppet:///modules/codesearch/Makefile.config",
    owner    => 'nelhage',
    group    => 'nelhage',
    require  => Vcsrepo['/home/nelhage/codesearch']
  }
  file { '/home/nelhage/codesearch/web/config.local.js':
    source   => "puppet:///modules/codesearch/config.local.js",
    owner    => 'nelhage',
    group    => 'nelhage',
    require  => Vcsrepo['/home/nelhage/codesearch']
  }
  file { '/home/nelhage/codesearch/web/log4js.codesearch.json':
    source   => "puppet:///modules/codesearch/log4js.codesearch.json",
    owner    => 'nelhage',
    group    => 'nelhage',
    require  => Vcsrepo['/home/nelhage/codesearch']
  }

  file { '/home/nelhage/codesearch/web/log':
    ensure => 'symlink',
    target => '/mnt/log',
    require => Vcsrepo['/home/nelhage/codesearch']
  }

  package { 'supervisor':
    ensure => 'installed'
  }

  file { '/etc/supervisor/conf.d/':
    source  => 'puppet:///modules/codesearch/supervisor',
    recurse => true,
    purge   => false,
    owner   => 'root',
    group   => 'root'
  }
}

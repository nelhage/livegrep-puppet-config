class codesearch::app {
  include daemontools

  file { '/home/nelhage/linux':
    ensure => 'directory',
    owner  => 'nelhage',
    group  => 'nelhage',
  }

  $idx_url = "https://s3.amazonaws.com/livegrep/codesearch.idx"
#  exec { "codesearch.idx":
#    command => "wget -N ${idx_url}",
#    cwd     => "/home/nelhage/linux/",
#    creates => "/home/nelhage/linux/codesearch.idx",
#    require => File['/home/nelhage/linux'],
#    user    => 'nelhage',
#    path    => '/usr/bin:/bin'
#  }

  file { '/home/nelhage/build-codesearch':
    source => 'puppet:///modules/codesearch/build-codesearch',
    owner  => 'nelhage',
    group  => 'nelhage',
    mode   => 0755
  }

  exec { '/home/nelhage/build-codesearch':
    creates => '/home/nelhage/codesearch/codesearch',
    cwd     => '/home/nelhage',
    user    => 'nelhage',
    require => [File['/home/nelhage/codesearch/Makefile.config'],
                File['/home/nelhage/sw/.installed']]
  }

  file { '/mnt/log':
    ensure => 'directory',
    owner  => 'nelhage',
    group  => 'nelhage',
    mode   => 0755
  }

  codesearch::util::checkout { '/home/nelhage/linux':
    source => "git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git"
  }

  codesearch::util::checkout { '/home/nelhage/codesearch':
    source   => "http://github.com/nelhage/livegrep",
    revision => 'origin/master',
  }
  file { '/home/nelhage/codesearch/Makefile.config':
    source   => "puppet:///modules/codesearch/Makefile.config",
    owner    => 'nelhage',
    group    => 'nelhage',
    require  => Vcsrepo['/home/nelhage/codesearch'];
  '/home/nelhage/codesearch/js/config.local.js':
    source   => "puppet:///modules/codesearch/config.local.js",
    owner    => 'nelhage',
    group    => 'nelhage',
    require  => Vcsrepo['/home/nelhage/codesearch'];
  '/home/nelhage/codesearch/js/aosp.json':
    source   => "puppet:///modules/codesearch/aosp.json",
    owner    => 'nelhage',
    group    => 'nelhage',
    require  => Vcsrepo['/home/nelhage/codesearch'];
  '/home/nelhage/codesearch/js/log4js.codesearch.json':
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
    ensure => absent
  }

  daemontools::service { 'web-server':
    program  => "node /home/nelhage/codesearch/bin/web_server.js --production",
    preamble => "cd /home/nelhage/codesearch",
    user     => 'nelhage'
  }

  daemontools::service { 'cs-server-linux':
    program  => "node /home/nelhage/codesearch/bin/cs_server.js -b linux",
    preamble => "cd /home/nelhage/codesearch",
    user     => 'nelhage'
  }

  daemontools::service { 'cs-server-aosp':
    program  => "node /home/nelhage/codesearch/bin/cs_server.js -b aosp",
    preamble => "cd /home/nelhage/codesearch",
    user     => 'nelhage'
  }

  daemontools::service { 'cs-server':
    program => '',
    ensure => absent
  }

  file { '/etc/logrotate.d/codesearch':
    source  => 'puppet:///modules/codesearch/logrotate.conf',
    owner   => 'root',
    group   => 'root',
  }
}

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

}

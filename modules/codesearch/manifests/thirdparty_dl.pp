class codesearch::thirdparty_dl {
  $sw_url = "https://livegrep.s3.amazonaws.com/3rdparty-sw.tar.gz"
  exec { "$sw_url":
    command => "wget -N ${sw_url}",
    cwd     => "/home/nelhage/",
    creates => "/home/nelhage/3rdparty-sw.tar.gz",
    user    => 'nelhage',
    path    => '/usr/bin:/bin'
  }

  exec { "unpack sw":
    command => "tar xzf 3rdparty-sw.tar.gz",
    cwd     => "/home/nelhage/",
    creates => "/home/nelhage/sw/.installed",
    user    => 'nelhage',
    path    => '/usr/bin:/bin',
    require => Exec["$sw_url"]
  }

  file { '/home/nelhage/sw/.installed':
    require => Exec['unpack sw'],
    ensure  => file
  }
}

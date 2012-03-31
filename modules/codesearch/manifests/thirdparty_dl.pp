class codesearch::thirdparty_dl {
  $tgz    = "3rdparty-sw-${lsbdistcodename}.tar.gz"
  $sw_url = "https://livegrep.s3.amazonaws.com/${tgz}"
  exec { "$sw_url":
    command => "wget -N ${sw_url}",
    cwd     => "/home/nelhage/",
    creates => "/home/nelhage/${tgz}",
    user    => 'nelhage',
    path    => '/usr/bin:/bin'
  }

  exec { "unpack sw":
    command => "tar xzf ${tgz}",
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

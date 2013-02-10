class codesearch {
  $deps = 'apt'

  user {
    'nelhage':
      uid        => 10000,
      managehome => true,
      shell      => '/bin/bash',
  }

  package { 'sudo':
    ensure => installed
  }

  define ssh_keys {
    $user = $name
    ssh_authorized_key { "nelhage@phanatique/$user":
      ensure => present,
      type   => 'ssh-dss',
      user   => $user,
      key    => 'AAAAB3NzaC1kc3MAAACBAJbQ2LSW72VlhOlaJSnfD3HJtFuHcqzDAULHzW5qusmcPQ0NJ0fL80M6wFDKONwOmIvM2r7q1I0P8B30AgQy/kIiRH1dEX3bSBlqaHx1rJV0+fSvrIkG6UDQ//JR8zGONtUBYjHnVRnMgXVBRXYJrkVN2/iwnN94aYareDzrVGW1AAAAFQCYfEJmylkxGiEnF/HZ81/mA4NDEQAAAIBQlay7gtJk0ibPtXXyz+mtK8A1EjzII7OFVUpE0SgxDDqCc//sfVyustpmkB0fKxjlaKN0HktuaZVpD5IpKNmSCYAG99wT0/5Ezg2dYjEVI/S9rT5GC5sewtH9p/metTSF14Uk11GwijEv4k62Hb8uElm6b4UKDi28dOrTWMM7nAAAAIBx/I+tx9dpwl5tt6Y6uYbvgJo0Poo+98e1YjY4R3RGrPuuq/BeWG6knTVAwPsFuFTnBG9X/SefV+7O/TuISQ+wW9Q6Khslv9hCSzdoko5FLc+wHXTW3BCINDbVryCR3cEsPJk9PghsiNuitFZrgyJIDc53uEiZYgEk/7QqP1zhQQ=='
    }

    ssh_authorized_key { "nelhage@psychotique/$user":
      ensure => present,
      type   => 'ssh-rsa',
      user   => $user,
      key    => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAu/fEf/HZ8pySx/WKc2GzhCfjLYHorVfRnxVPnu5vJUiVwE311rRkSs64Qz0E017SbapEBI8LS+1dpHr85rgjQINaXN36C/z5KJ0kQFQ56kqqMk6UlnutoogY26NEfk9wwWj4FMStXVGCQUIvBxW6fMWA/kNSNFpecWOmI2sAYcNpJ6nqXUVz3HHYDbStltQwifMkgmkKM2Wps2Gdp07ltz6l/q75IEay21SQz+k4PMBbrJut+I3V2T+IjRnU4FUEfYtQMxy2taLUghIaiRLzWSO9j21wPMxgCSasholy4i2+OjAPCkMh/y/yPW6s3uTsvO2nsmQ67Hq8lVq6j0YO6Q=='
    }
  }

  ssh_keys { ['root', 'nelhage']: }

  file { '/etc/sudoers.d/01nelhage':
    source => 'puppet:///modules/codesearch/01nelhage',
    mode   => '0440',
    owner  => 'root',
    group  => 'root'
  }

  file { '/etc/security/limits.d/memlock.conf':
    source => 'puppet:///modules/codesearch/memlock.conf',
    mode   => '0644',
    owner  => 'root',
    group  => 'root'
  }

  package { ['git', 'vim-nox', "emacs23-nox", 'tmux',
             'psutils', 'psmisc', 'strace', 'subversion']:
    ensure => installed
  }

  define dotfile {
    file { "/home/nelhage/.${name}":
      source => "puppet:///modules/codesearch/nelhage/.${name}",
      ensure => 'file',
      owner  => 'nelhage',
      group  => 'nelhage',
      require => User['nelhage']
    }
  }

  dotfile { ['tmux.conf', 'bashrc', 'environment', 'gitconfig', 's3cfg']: }

  # Development stuff

  package { ['build-essential', 'libsparsehash-dev', 'libjson0-dev',
             'cmake', 'zlib1g-dev', 'python', 'libssl-dev', 'gdb',
             'autotools-dev', 'autoconf', 'libtool', 'libboost-dev',
             's3cmd']:
    ensure => installed
  }

  file { '/home/nelhage/sw':
    ensure => 'directory',
    owner  => 'nelhage',
    group  => 'nelhage',
    checksum => 'none'
  }

  include codesearch::nginx
  include codesearch::app
  include codesearch::monitoring

  case $deps {
    build: { include codesearch::thirdparty }
    dl: { include codesearch::thirdparty_dl }
    apt: { include codesearch::thirdparty_apt }
  }
}

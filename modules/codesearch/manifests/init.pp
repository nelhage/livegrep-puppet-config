class codesearch {
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

  file { '/home/nelhage/.ssh':
    source => 'puppet:///modules/codesearch/nelhage/.ssh',
    ensure => 'directory',
    recurse => 'true',
    purge  => 'false',
    owner  => 'nelhage',
    group  => 'nelhage',
    require => User['nelhage']
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

  dotfile { ['tmux.conf', 'bashrc', 'environment', 'gitconfig']: }

  sshkey { 'nelhage.com':
    type => 'ssh-rsa',
    key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAu8bGx+toQQl4ey3UgiQwj9RmCCpJbIyGDQnzCb0yMsMbAfLQwTRyIo9P71YJ3PYL+Egn2iEhWHZpz/1cetJWED8EcGAliuFhWjIA71CgOVGpQMlMCPeWN0rhvadqmHzA4R6/QRp4hjbxDPS7qmfM0ZwbMl4eDFmdifrdVTAFEmSrSunXBDUiRFbToMOA8SIhlHs/O07SJ2OhM0UgHOTZzCuQJ2fVWpzQHbgxrYRqTshXRgA2eIi9pBFCyOH6WUWS+YNCV4xU6yJQdmayA/q2yer0JWlU6a06fiTpSNCN8HZdhuEaVfka/7jIrFmO+jGxKTcvhqTNfNQjDnqaQCejpw=='
  }

  # Development stuff

  package { ['build-essential', 'libsparsehash-dev', 'libjson0-dev',
             'cmake', 'zlib1g-dev', 'python', 'libssl-dev', 'gdb',
             'g++-multilib', 'lib32z1-dev', 'ia32-libs', 'autotools-dev',
             'autoconf', 'libtool', 'libboost-dev']:
    ensure => installed
  }

  file { '/home/nelhage/sw':
    ensure => 'directory',
    owner  => 'nelhage',
    group  => 'nelhage',
    checksum => 'none'
  }

  define checkout ($source, $provider = 'git', $revision = undef) {
    vcsrepo { "$name":
      ensure   => present,
      provider => $provider,
      source   => $source,
      require  => [User['nelhage'], Sshkey['nelhage.com'],
                   Package['git'], Package['subversion']],
      identity => '/home/nelhage/.ssh/id_rsa',
      revision => $revision,
      owner    => 'nelhage',
      group    => 'nelhage'
    }
  }

  checkout { '/home/nelhage/codesearch':
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
  checkout { '/home/nelhage/libgit2':
    source => "https://github.com/libgit2/libgit2.git"
  }
#  checkout { '/home/nelhage/linux':
#    source => "git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git"
#  }

  checkout { '/home/nelhage/gflags':
    source  => 'http://google-gflags.googlecode.com/svn/trunk',
    provider => 'svn'
  }
  checkout { '/home/nelhage/node':
    source => 'https://github.com/joyent/node.git',
    revision => 'v0.6'
  }
  checkout { '/home/nelhage/npm':
    source => 'https://github.com/isaacs/npm.git'
  }
  checkout { '/home/nelhage/json-c':
    source => 'https://github.com/json-c/json-c.git'
  }

  include codesearch::nginx
  include codesearch::app
}

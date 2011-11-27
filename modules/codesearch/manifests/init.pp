class codesearch {
  user {
    'nelhage':
      uid        => 1000,
      managehome => true,
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
  }

  ssh_keys { ['root', 'nelhage']: }

  file { '/etc/sudoers.d/01nelhage':
    source => 'puppet:///modules/codesearch/01nelhage',
    mode   => '0440',
    owner  => 'root',
    group  => 'root'
  }

  package { ['git', 'vim-nox', "emacs23-nox", 'tmux']:
    ensure => installed
  }

  file { '/home/nelhage/':
    source => 'puppet:///modules/codesearch/nelhage',
    ensure => 'directory',
    recurse => 'true',
    purge  => 'false',
    owner  => 'nelhage',
    group  => 'nelhage',
    require => User['nelhage']
  }


  # Development stuff

  package { ['build-essential', 'libsparsehash-dev']:
    ensure => installed
  }

}

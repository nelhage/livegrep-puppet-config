class codesearch::thirdparty {
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

  file { '/home/nelhage/build-all':
    source => 'puppet:///modules/codesearch/build-all',
    owner  => 'nelhage',
    group  => 'nelhage',
    mode   => 0755
  }

#  exec { '/home/nelhage/build-all':
#    cwd     => '/home/nelhage',
#    creates => '/home/nelhage/sw/.installed',
#    user    => 'nelhage',
#    timeout => 0,
#    require => [Checkout['/home/nelhage/gflags'],
#                Checkout['/home/nelhage/node'],
#                Checkout['/home/nelhage/npm'],
#                Checkout['/home/nelhage/json-c']]
#  }
#
#  file { '/home/nelhage/sw/.installed': }
}

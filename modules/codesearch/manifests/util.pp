class codesearch::util {
  define checkout ($source, $provider = 'git', $revision = undef) {
    vcsrepo { "$name":
      ensure   => present,
      provider => $provider,
      source   => $source,
      require  => [User['nelhage'],
                   Package['git'], Package['subversion']],
      identity => '/home/nelhage/.ssh/id_rsa',
      revision => $revision,
      owner    => 'nelhage',
      group    => 'nelhage'
    }
  }
}

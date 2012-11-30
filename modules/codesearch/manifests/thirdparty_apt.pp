class codesearch::thirdparty_apt {
  include apt::params
  apt::ppa { 'ppa:nelhage/livegrep': }
  apt::ppa { 'ppa:chris-lea/node.js': }
  package { ['nodejs', 'npm', 're2-dev', 'libgit2-dev', 'gflags-dev']:
    ensure => latest,
    require => [Apt::Ppa['ppa:nelhage/livegrep'], Apt::Ppa['ppa:chris-lea/node.js']],
    before  => File['/home/nelhage/sw/.installed']
  }

  file { $apt::params::sources_list_d:
    ensure => directory
  }

  file { '/home/nelhage/sw/.installed':
    ensure  => file
  }
}

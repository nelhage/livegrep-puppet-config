define daemontools::service(
  $program,
  $logfile  = false,
  $user     = 'root',
  $preamble = '',
  $ensure   = 'running') {
    if $ensure == 'absent' {
      file { "/etc/service/$name":
        ensure => 'absent',
        recurse => true
      }
    } else {
      file { "/etc/service/$name":
        ensure => directory
      }

      file { "/etc/service/$name/run":
        ensure   => present,
        content  => template('daemontools/run.erb'),
        mode     => 0755,
        require  => [File["/etc/service/$name"],
                     File["/etc/service/$name/log/run"]]
      }

      file { "/etc/service/$name/log":
        ensure   => directory,
        require  => [File["/etc/service/$name"]]
      }

      file { "/etc/service/$name/log/run":
        content  => template('daemontools/multilog.erb'),
        mode     => 0755
      }

      file { "/etc/service/$name/down":
        ensure => $ensure ? {
          'running' => false,
          'present' => true
        }
      }
    }
}

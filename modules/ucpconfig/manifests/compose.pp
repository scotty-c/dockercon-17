class ucpconfig::compose {

  file { ['/etc/interlock', '/etc/jenkins']:
    ensure => directory,
    }

  file { '/etc/interlock/docker-compose.yml':
    ensure  => file,
    content => template('ucpconfig/interlock.yml.erb'),
    require => File['/etc/interlock', '/etc/jenkins'],
    }

  exec { 'docker-compose-interlock':
    command => 'bash -l -c "docker-compose -f /etc/interlock/docker-compose.yml up -d"',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    timeout => '1800',
    require => Class['ucpconfig::config'],
    }

  
  file { '/etc/jenkins/docker-compose.yml':
    ensure  => file,
    content => template('ucpconfig/jenkins.yml.erb'),
    require => File['/etc/interlock', '/etc/jenkins'],
    }

  exec { 'docker-compose-jenkins':
    command => 'bash -l -c "docker-compose -f /etc/jenkins/docker-compose.yml up -d"',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    timeout => '1800',
    require => [ Class['ucpconfig::config'], Exec['docker-compose-interlock']]
    }
}

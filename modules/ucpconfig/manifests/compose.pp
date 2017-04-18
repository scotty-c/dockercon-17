class ucpconfig::compose {

  file { ['/etc/interlock', '/etc/jenkins', '/etc/elk']:
    ensure => directory,
    }

  file { '/etc/interlock/docker-compose.yml':
    ensure  => file,
    content => template('ucpconfig/interlock.yml.erb'),
    require => File['/etc/interlock', '/etc/jenkins', '/etc/elk'],
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
    require => File['/etc/interlock', '/etc/jenkins', '/etc/elk'],
    }


  exec { 'docker-compose-jenkins':
    command => 'bash -l -c "docker-compose -f /etc/jenkins/docker-compose.yml up -d"',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    timeout => '1800',
    require => [ Class['ucpconfig::config'], Exec['docker-compose-interlock']]
    }
 
 exec { 'dtr':
    command => 'bash -l -c "docker run -t --rm docker/dtr install --dtr-external-url https://172.17.10.103 --ucp-node ucp-03 --ucp-username admin --ucp-password orca4307  --ucp-insecure-tls --ucp-url https://172.17.10.101"',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    timeout => '3600',
    require => [ Class['ucpconfig::config'], Exec['docker-compose-interlock']]
    }

  vcsrepo {'/etc/dockercon/':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/jzaccone/office-space-dockercon2017.git',
   }->

   exec { 'docker-compose-dockercon':
    command => 'bash -l -c "docker-compose -f /etc/dockercon/docker-compose.yml up -d"',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    timeout => '3600',
    require => [ Class['ucpconfig::config'], Exec['docker-compose-interlock']]
    }  

}

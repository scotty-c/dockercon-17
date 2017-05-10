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
    command => 'docker-compose -f /etc/jenkins/docker-compose.yml up -d',
    environment => 'HOME=/root',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    require => [ Class['ucpconfig::config'], Exec['docker-compose-interlock']]
    }
 
  docker_ucp::dtr {'Dtr install':
    install => true,
    dtr_version => 'latest',
    dtr_external_url => 'https://172.17.10.104',
    ucp_node => 'ucp-04',
    ucp_username => 'admin',
    ucp_password => 'orca4307',
    ucp_insecure_tls => true,
    dtr_ucp_url => 'https://172.17.10.101',
    require => [ Class['ucpconfig::config'], Exec['docker-compose-interlock']] 
    } ->
   
  
   vcsrepo {'/etc/dockercon/':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/jzaccone/office-space-dockercon2017.git',
   }->

   exec { 'docker-compose-dockercon':
    command => 'docker-compose -f /etc/dockercon/docker-compose.yml up -d',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    environment => 'HOME=/root',
    timeout => 0,
    require => [ Class['ucpconfig::config'], Exec['docker-compose-interlock']]
    }  
}

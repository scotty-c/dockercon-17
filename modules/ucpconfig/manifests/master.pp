class ucpconfig::master(

  $ucp_version                   = $ucpconfig::ucp_version,
  $ucp_host_address              = $ucpconfig::ucp_host_address,
  $ucp_username                  = $ucpconfig::ucp_username,
  $ucp_password                  = $ucpconfig::ucp_password,
  $ucp_subject_alternative_names = $ucpconfig::ucp_subject_alternative_names,
  $ucp_external_ca               = $ucpconfig::ucp_external_ca,
  $ucp_swarm_scheduler           = $ucpconfig::ucp_swarm_scheduler,
  $ucp_swarm_port                = $ucpconfig::ucp_swarm_port,
  $ucp_controller_port           = $ucpconfig::ucp_controller_port,
  $ucp_preserve_certs            = $ucpconfig::ucp_preserve_certs,
  $ucp_license_file              = $ucpconfig::ucp_license_file,

) {
  
file {'/root/.docker/':
  ensure => directory
  } ->  
  
file { '/root/.docker/config.json':
  ensure  => present,
  content => template('ucpconfig/config.json.erb'),
  } ->   


class { 'docker_ucp':
  controller                => true,
  host_address              => $ucp_host_address,
  version                   => $ucp_version,
  username                  => $ucp_username,
  password                  => $ucp_password,
  usage                     => false,
  tracking                  => false,
  subject_alternative_names => $ucp_subject_alternative_names,
  external_ca               => $ucp_external_ca,
  swarm_scheduler           => $ucp_swarm_scheduler,
  swarm_port                => $ucp_swarm_port,
  controller_port           => $ucp_controller_port, 
  preserve_certs            => $ucp_preserve_certs,
  docker_socket_path        => '/var/run/docker.sock',
  license_file              => $ucp_license_file,
  require                   => Class['docker']
  } ->
  
  file { '/etc/etcd':
    ensure => directory,
  } ->

  file { '/etc/etcd/docker-compose.yml':
    ensure  => file,
    content => template('ucpconfig/etcd.yml.erb'),
    require => File['/etc/etcd'],
   } ->

  docker_compose { '/etc/etcd/docker-compose.yml':
    ensure  => present,
    require => File['/etc/etcd/docker-compose.yml']
    }
}

class ucpconfig::config (
  
  $ucp_url               = $ucpconfig::ucp_url,
  $ucp_username          = $ucpconfig::ucp_username,
  $ucp_password          = $ucpconfig::ucp_password,
  $docker_network        = $ucpconfig::docker_network,
  $docker_network_driver = $ucpconfig::docker_network_driver,
  $docker_cert_path      = $ucpconfig::docker_cert_path,
  $docker_host           = $ucpconfig::docker_host,
  $consul_master_ip      = $ucpconfig::consul_master_ip,
  ) {


  package { ['zip', 'jq']:
    ensure => installed,
    } ->

  file { '/etc/docker/get_ca.sh':
    ensure  => file,
    content => template('ucpconfig/get_ca.sh.erb'),
    } ->

  exec { 'ca_bundle':
    command => 'sh get_ca.sh',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    cwd     => $docker_cert_path,
    creates => "${$docker_cert_path}/ca.pem",
    require => File['/etc/docker/get_ca.sh'],
    }->

    file { '/etc/profile.d/docker.sh':
    ensure  => present,
    content => template('ucpconfig/docker.sh.erb'),
    mode    => '0644',
    }

  case $::hostname {
    'ucp-01': {
       docker_network { $docker_network:
         ensure  => present,
         driver  => $docker_network_driver,
         require => File['/etc/profile.d/docker.sh'],
         }
      }
  default: { notify {"Docker network can not be create on ${::hostname}":} }

    }  
}           

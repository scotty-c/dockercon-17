# Class: swarmconfig
# ===========================
#
# Full description of class swarmconfig here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'swarmconfig':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class swarmconfig (
  

){

  class { 'docker':
    package_name            => 'docker-ce',
    package_source_location => '[arch=amd64] https://download.docker.com/linux/ubuntu',
    package_key_source      => 'https://download.docker.com/linux/ubuntu/gpg',
    package_key             => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88',
    package_repos           => 'stable',
    package_release         => 'trusty',
    tcp_bind                => 'tcp://127.0.0.1:4243',
    socket_bind             => 'unix:///var/run/docker.sock',
    }

  docker::swarm {'cluster_manager':
    init           => true,
    advertise_addr => "${::ipaddress_eth1}",
    listen_addr    => "${::ipaddress_eth1}",
    require        => Class['docker'] 
  } 
}

#!/usr/bin/ruby env

require "socket"
$hostname = Socket.gethostname

forge 'http://forge.puppetlabs.com'

mod 'garethr/docker', :git => 'https://github.com/garethr/garethr-docker.git'
mod 'puppetlabs/apt', '2.4.0'
mod 'puppetlabs/docker_ucp', :git => 'https://github.com/puppetlabs/puppetlabs-docker_ucp.git'
mod 'puppetlabs/stdlib', :git => 'https://github.com/puppetlabs/puppetlabs-stdlib.git'
mod 'maestrodev/wget', :git => 'https://github.com/maestrodev/puppet-wget.git'
mod 'puppetlabs/vcsrepo'

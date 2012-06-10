class boxes::setupbox {

  # the update
  Exec { path => ['/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'], logoutput => true }
  include apt::update
  #Package [require => Exec['apt_update']]
  Exec["apt_update"] -> Package <| |>

  # install software

  # install apache + php
  include apache::php

  # install additional php-packages
  package{$boxes:php_packages:
    ensure => "installed",
    require => Class["apache::php"],
  }

  # add mysql with password
  class {'mysql::server':
    config_hash => { 'root_password' => "$boxes::mysql_password" }
  }

  # install augeas
  include augeas

  # install apc
  #include apc

  # add user vagrant to group www-data
  user {"vagrant":
    groups => "$boxes::www_group",
  }

  # TODO: install mongodb

  Class["augeas"] -> Class["apache::php"] -> Class["mysql::server"]
    
}
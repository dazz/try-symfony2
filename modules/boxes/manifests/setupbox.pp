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
  package{ ["php5-intl","php5-mysql"]:
    ensure => "installed",
    require => Class["apache::php"],
  }

  # add mysql with password
  class {'mysql::server':
    config_hash => { 'root_password' => 'vagrant' }
  }

  # install augeas
  include augeas

  # install apc
  #include apc

  # add user vagrant to group www-data
  user {"vagrant":
    groups => "www-data",
  }

  Class["augeas"] -> Class["apache::php"] -> Class["mysql::server"]
    
}
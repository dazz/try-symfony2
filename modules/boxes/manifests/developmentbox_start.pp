class boxes::developmentbox_start {

  # the update
  Exec { path => ['/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'], logoutput => true }
  include apt::update
  #Package [require => Exec['apt_update']]
  Exec["apt_update"] -> Package <| |>

  # install software starts here

  # add user:
  create_resources(user, $boxes::dev_users)

  package {$package_list:
    ensure => present
  }

}
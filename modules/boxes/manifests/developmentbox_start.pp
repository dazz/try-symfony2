class boxes::developmentbox_start {

    # the update
    Exec { path => ['/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'], logoutput => true }
    include apt::update
    #Package [require => Exec['apt_update']]
    Exec["apt_update"] -> Package <| |>

    # put here your tools
    $package_list = ['git-flow']

    package {$package_list:
        ensure => present
    }

    # your stuff here

}

#    define ssh::user($user = "${name}", $home = "/home/${name}") {
#
#      User[$user] -> File[$home] -> file { "$home/.ssh/":
#        ensure => directory,
#      } -> file {
#        ensure => present,
#        content => templates("ssh/user/known_hosts.erb"),
#        owner => $user,
#        mode => "0420"
#      }
#    }
class boxes::basebox {

  # the update
  Exec { path => ['/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'], logoutput => true }
  include apt::update
  #Package [require => Exec['apt_update']]
  Exec["apt_update"] -> Package <| |>

  # fix udev rules
  file {"/etc/udev/rules.d/70-persistent-net.rules":
    ensure => absent,
  }

  # fix udev rules generator
  file {"/lib/udev/rules.d/75-persistent-net-generator.rules":
    ensure => absent,
  }

  # add sources list of debian squeeze german
  apt::source {"debian_squeeze_german":
    location          => "http://ftp.de.debian.org/debian/",
    release           => "squeeze",
    repos             => "main contrib",
    include_src       => true
   }
  
  # delete present mirrors
  file {"/etc/apt/sources.list":
    ensure => absent,
  }
    
  class {'locales':
    locales => ['de_DE.UTF-8 UTF-8'],
  }

  # TODO:
  # update puppet, because some modules require a newer version than there might be installed

  # update facter
}
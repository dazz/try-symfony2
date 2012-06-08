class boxes::basebox {

  # the update
  Exec { path => ['/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'], logoutput => true }
  include apt::update
  #Package [require => Exec['apt_update']]
  Exec["apt_update"] -> Package <| |>

  # fix udev rules
  exec { "fix_udev_rules":
    command => "rm -f /etc/udev/rules.d/70-persistent-net.rules"
  }

  # fix udev rules generator
  exec { "fix_udev_generator":
    command => "rm -f /lib/udev/rules.d/75-persistent-net-generator.rules"
  }

  # your stuff here

  # add sources list
  apt::source { "debian_squeeze_german":
    location          => "http://ftp.de.debian.org/debian/",
    release           => "squeeze",
    repos             => "main contrib",
    include_src       => true
   }
  
  # delete present mirrors
  file { "/etc/apt/sources.list":
    ensure => absent,
  }
    
  class { 'locales':
    locales => [ 'de_DE.UTF-8 UTF-8'],
  }
}
class boxes::basebox {

  include boxes

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
  apt::source {"debian_squeeze_sources":
    location          => "$boxes::apt_sources_location",
    release           => "squeeze",
    repos             => "main contrib",
    include_src       => true
   }

  # delete present mirrors
  file {"/etc/apt/sources.list":
    ensure => absent,
  }

  # add DE locales
  class {'locales':
    locales => ['de_DE.UTF-8 UTF-8'],
  }

  # update puppet and facter, because some modules require a newer version than there might be installed

  # install new veriosn of facter
  package {"facter":
      ensure => installed
  }

  exec {"rename current facter":
      command => "mv /usr/local/bin/facter /usr/local/bin/facter1.5.8",
      user => root,
      cwd => "/usr/local/bin",
      creates => "/usr/local/bin/facter1.5.8"
  }

  exec {"link new facter":
      command => "ln -s /usr/bin/facter /usr/local/bin/facter",
      user => root,
      cwd => "/usr/bin/",
      creates => "/usr/local/bin/facter"
  }

  Package["facter"] -> Exec["rename current facter"] -> Exec["link new facter"]

  # install new version of puppet
  package {"puppet":
      ensure => installed
  }

  exec{"rename current puppet":
      command => "mv /usr/local/bin/puppet /usr/local/bin/puppet_old",
      user => root,
      cwd => "/usr/local/bin",
      creates => "/usr/local/bin/puppet_old"
  }

  exec{"link new puppet":
      command => "ln -s /usr/bin/puppet /usr/local/bin/puppet",
      user => root,
      cwd => "/usr/bin",
      creates => "/usr/local/bin/puppet"
  }

  Package["puppet"] -> Exec["rename current puppet"] -> Exec["link new puppet"]
}


class boxes::developmentbox {

  include littlebird::params
  $projectname = "phoenix-dev"

  # the update
  Exec { path => ['/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'], logoutput => true }
  include apt::update
  #Package [require => Exec['apt_update']]
  Exec["apt_update"] -> Package <| |>

  # put here your tools
  $package_list = ['vim', 'aptitude', 'sudo', 'mc', 'screen', 'zsh']

  package {$package_list:
      ensure => present
  }

  # your stuff here

  # TODO: Externalize globals
  $projectname = "symfony"
  $install_dir = "/var/www"
  $composer_install_dir = "$install_dir/$projectname"

  # download composer
  class {"composer":
    targetdir => "$composer_install_dir",
  }

  # run composer install
  exec { "install composer":
    command => "php composer.phar",
    require =>[
        Class["composer"],
    ],
    user => root,
    logoutput => 'on_failure',
    cwd => "$composer_install_dir",
    timeout => 0,
  }

  # install xdebug
  package {"php5-xdebug":
      ensure => present,
  }

  # install nodejs
  $version = "stable"
  class{'nodejs':
    version => $version,
  }

  # install nodejs packages
  $packages = ["zombie"]
  installnodejspackage{$packages:}

  package {"rubygems1.8":
    ensure => present,
  }

  $gems = ['compass','sass']
  installgems{$gems:}

  Class["composer"] -> Exec["install composer"]
}

define installnodejspackage($log = 'on_failure'){
    exec { "install $name":
        command     => "npm install $name",
        require     => Class["nodejs"],
        user        => root,
        logoutput   => $log,
        creates     => "/usr/local/bin/node_modules/$name",
        cwd         => "/usr/local/bin/",
    }
}

define installgems($log = 'on_failure'){
    exec { "install $name":
		command     => "gem install $name",
        user        => root,
        logoutput   => $log,
        creates     => "/var/lib/gems/1.8/bin/$name",
        cwd         => "/usr/bin/",
        require     => Package["rubygems1.8"],
	}
}
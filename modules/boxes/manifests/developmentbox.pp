class boxes::developmentbox {

  include boxes

  # the update
  Exec { path => ['/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'], logoutput => true }
  include apt::update
  #Package [require => Exec['apt_update']]
  Exec["apt_update"] -> Package <| |>

  # install software starts here

  # download composer
  class {"composer":
    targetdir => "$boxes::composer_dir",
  }

  # test run composer
  exec {"install composer":
    command => "php composer.phar",
    require =>[
        Class["composer"],
        Class["apache::php"],
    ],
    user => root,
    logoutput => 'on_failure',
    cwd => "$boxes::composer_dir",
    timeout => 0,
  }

  $packages = ["php5-xdebug", "rubygems1.8"]

  # install packages
  package {$packages:
      ensure => present,
  }

  # install nodejs
  class {'nodejs':
    version => "$boxes::nodejs_version",
  }

  # install nodejs packages
  installnodejspackage {$boxes::nodejs_packages: }

  # install gems
  installgems {$boxes::gems: }

  package {"$boxes::dev_packages":
    ensure => present
  }

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
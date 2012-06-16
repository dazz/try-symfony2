class boxes::testbox {

    include boxes

    # the update
    Exec { path => ['/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'], logoutput => true }
    include apt::update
    #Package [require => Exec['apt_update']]
    Exec["apt_update"] -> Package <| |>

    # software installation starts here

    # install pear
    package {"php-pear":
      ensure => present
    }
    
    exec {"upgrade pear":
      command => "pear upgrade PEAR",
      user => root,
    }
    
    exec {"add pear channel php-unit":
      command => "pear channel-discover pear.phpunit.de",
      user => root,
      unless => "pear channel-info pear.phpunit.de"
    }
    
    exec {"add pear channel symfony":
      command => "pear channel-discover pear.symfony-project.com",
      user => root,
      unless => "pear channel-info pear.symfony-project.com"
    }
    
    exec {"install phpunit":
      command => "pear install --alldeps phpunit/PHPUnit-3.6.11",
      user => root,
      unless => "pear info phpunit/PHPUnit-3.6.11"
    }
    
    Package["php-pear"]
    -> Exec["upgrade pear"]
    -> Exec["add pear channel php-unit"]
    -> Exec["add pear channel symfony"]
    -> Exec["install phpunit"]
}
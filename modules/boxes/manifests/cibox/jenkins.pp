class boxes::cibox::jenkins {

    include apt

    apt::key { "jenkins":
      key        => "D50582E6",
      key_source => "http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key",
    }

#    define apt::source(
#      $ensure            = present,
#      $location          = '',
#      $release           = $lsbdistcodename,
#      $repos             = 'main',
#      $include_src       = true,
#      $required_packages = false,
#      $key               = false,
#      $key_server        = 'keyserver.ubuntu.com',
#      $key_content       = false,
#      $key_source        = false,
#      $pin               = false
#    ) {

    apt::source { "jenkins":
      location          => "http://pkg.jenkins-ci.org/debian/",
      key_content       => "deb http://pkg.jenkins-ci.org/debian binary/"
    }

    Apt::Key["jenkins"] -> Apt::Source["jenkins"]

    package {"jenkins":
        ensure  => "installed",
        require => Apt::Source["jenkins"],
#        user    => root
    }

    service {"jenkins":
        enable  => true,
        ensure  => "running",
        hasrestart => true,
        require => Package["jenkins"],
    }
}
class boxes::cibox::jenkins {

    include apt

    apt::key { "jenkins":
      key        => "D50582E6",
      key_source => "http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key",
    }

    apt::source { "jenkins":
      location          => "http://pkg.jenkins-ci.org/debian binary/",
      release           => "",
      include_src       => false,
      repos             => "",
    }

    Apt::Key["jenkins"] -> Apt::Source["jenkins"]

    package { "jenkins":
        ensure  => "installed",
        require => Apt::Source["jenkins"],
    }

    service { "jenkins":
        enable  => true,
        ensure  => "running",
        hasrestart => true,
        require => Package["jenkins"],
    }
}
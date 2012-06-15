class boxes::productionbox {

  include boxes

  # the update
  Exec { path => ['/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'], logoutput => true }
  include apt::update
  #Package [require => Exec['apt_update']]
  Exec["apt_update"] -> Package <| |>

  # installing software starts here

  # download from git into tempdir
  #class{'littlebird::download':
  #  projectname => $projectname,
  #  downloadurl => $littlebird::params::download_url,
  #}

  # copy from tempdir to installdir and set appropriate fole rigths
  #class{'littlebird::copy':
  #  projectname => $projectname,
  #  installdir => $littlebird::params::install_dir,
  #}

    # update Timezone php apache
  augeas{"Set PHPTimezone_apache" :
    context => "/files/etc/php5/apache2/php.ini/DATE",
    changes => "set date.timezone $boxes::php_ini_timezone",
  }

  # update Timezone php cli
  augeas{"Set PHPTimezone_phpcli" :
    context => "/files/etc/php5/cli/php.ini/DATE",
    changes => "set date.timezone $boxes::php_ini_timezone",
  }

  # update short_open_tag php cli
  augeas{"Set PHPshort_open_tag_phpcli" :
    context => "/files/etc/php5/cli/php.ini/PHP",
    changes => "set short_open_tag Off",
  }

  # update short_open_tag php apache
  augeas{"Set PHPshort_open_tag_phpapache" :
    context => "/files/etc/php5/apache2/php.ini/PHP",
    changes => "set short_open_tag Off",
  }

  # add vhost
  apache::vhost {"default":
    port => '80',
    #servername => "$boxes::vhost_servername",
    priority => '0',
    serveraliases => "$boxes::projectname",
    configure_firewall => false,
    docroot => "$boxes::vhost_docroot",
    template => "$boxes::vhost_template",
    vhost_name => '*',
    options => "Indexes FollowSymLinks MultiViews"
  }

  # change ownership of installdir to $user
  file{"$boxes::project_root"
    user => "$boxes::user",
    group => "$boxes::www_group",
    mode => 1775,
    recurse => true
  }
}
class boxes::productionbox {

  include littlebird::params

  # the update
  Exec { path => ['/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'], logoutput => true }
  include apt::update
  #Package [require => Exec['apt_update']]
  Exec["apt_update"] -> Package <| |>

  # your stuff here

  # TODO: Externalize globals
  $projectname = "symfony"
  $owner = "vagrant"
  $group = "www-data"

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

  # TODO: Externalize globals
  $timezone='Europe/Berlin'

  # update Timezone php apache
  augeas{"Set PHPTimezone_apache" :
    context => "/files/etc/php5/apache2/php.ini/DATE",
    changes => "set date.timezone $timezone",
  }

  # update Timezone php cli
  augeas{"Set PHPTimezone_phpcli" :
    context => "/files/etc/php5/cli/php.ini/DATE",
    changes => "set date.timezone $timezone",
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

  # TODO: Externalize globals
  $projectname = "symfony"
  $install_dir = "/var/www"
  $project_root = "$install_dir/$projectname"

  # add vhost
  apache::vhost {"default":
    port => '80',
    #servername => "$projectname",
    priority => '0',
    serveraliases => "$projectname",
    configure_firewall => false,
    docroot => "$project_root/web",
    template => 'apache/vhost-default.conf.erb',
    #require => Class["littlebird::copy"],
    vhost_name => '*',
    options => "Indexes FollowSymLinks MultiViews"
  }
    
  # change owership of installdir to $owner
  exec { "set $projectname owner":
  command => "chown -R $owner:$group $project_root",
    user => root,
    cwd => "$project_root",
    logoutput => true,
	}
    
  # change group of installdir to $group
  exec { "set $projectname mod":
    command => "chmod -R 1775 $project_root",
    user => root,
    cwd => "$project_root",
    logoutput => true,
	}
    
  #Class["littlebird::download"] -> Class["littlebird::copy"] -> Exec["set $projectname owner"] -> Exec["set $projectname mod"] -> Class["apache"]
}
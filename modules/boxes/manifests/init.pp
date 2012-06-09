class boxes {

  # basebox
  $boxes::apt_sources_location = "http://ftp.de.debian.org/debian/"

  # setupbox
  $php_packages      = ["php5-intl","php5-mysql", "php5-libxm"]
  $php_modules       = ["apc", "bcmath", "bz2", "Core", "ctype", "curl", "date", "dom", "ereg"]

  # productionbox
  $projectname       = "symfony"
  $user              = "vagrant"
  $www_group         = "www-data"

  # dirs and folders
  $install_dir       = "/var/www"
  $project_root      = "$install_dir/$projectname"

  # php_ini
  $php_ini_timezone  ='Europe/Berlin'

  # vhost config
  $vhost_template    = 'apache/vhost-default.conf.erb'
  $vhost_servername  = ''
  $vhost_docroot     = "$project_root/web"
}
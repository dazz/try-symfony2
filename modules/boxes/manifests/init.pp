class boxes {

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
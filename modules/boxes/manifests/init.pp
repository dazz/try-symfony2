class boxes {

  # basebox
  $apt_sources_location = "http://ftp.de.debian.org/debian/"

  # setupbox
  $php_packages      = ["php5-intl","php5-mysql", ]
  $php_modules       = ["apc", "bcmath", "bz2", "Core", "ctype", "curl", "date", "dom", "ereg"]
  $mysql_password    = 'vagrant'

  # productionbox
  $projectname       = "symfony"
  $user              = "vagrant"
  $www_group         = "www-data"

  ## dirs and folders
  $repo_url          = "https://github.com/symfony/symfony-standard.git"
  $install_dir       = "/var/www"
  $project_root      = "$install_dir/$projectname"

  ## php_ini
  $php_ini_timezone  = 'Europe/Berlin'

  ## vhost config
  $vhost_template    = 'apache/vhost-default.conf.erb'
  $vhost_servername  = ''
  $vhost_docroot     = "$project_root/web"

  # testbox

  # developmentbox
  $composer_dir      = ""

  ## put here your tools
  $dev_packages      = ['vim', 'aptitude', 'sudo', 'mc', 'screen', 'zsh', 'git-flow']

  $nodejs_version    = "stable"
  $nodejs_packages   = ["zombie"]
  $gems              = ['compass','sass']

  # developmentbox_start
  $dev_start_packages = []

  # [TODO] add your user
  $dev_start_users = {
    'nick' => {
      uid    => '1330',
      group  => allstaff,
      groups => ['www-data', 'vagrant'], }
   }

}
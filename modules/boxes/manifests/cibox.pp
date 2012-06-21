class boxes::cibox {

  include apt::update
  Exec { path => ['/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'], logoutput => true }
  Exec["apt_update"] -> Package <| |>

  class { 'boxes::cibox::jenkins': }

  group {
    'puppet' :
      ensure => present;
  }

  class { "webdev::bash_aliases": }

  boxes::cibox::jplugin {
    'git' : ,
    'vagrant' : ,
    'audit-trail' : ,
    'createjobadvanced' : ,
    'simple-theme-plugin' : ,
    'external-monitor-job' : ,
    'jenkinswalldisplay' : ,
    'all-changes' : ,
    'redmine' : ,
    'chucknorris' : ,
    'greenballs' : ,
  }

  package { ["htop", "vim"]:
    ensure => installed
  }
}
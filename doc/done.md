## basebox

* fix network (udev)
* update sources
* TODO: update puppet and facter

## setupbox

* install apache
* install php
* install php extensions php5-intl, php5-mysql, php5-libxm
* TODO: install mongoDB
* TODO: install php-modules (apc, mongo)
* install mysql server with user root, password vagrant
* install augeas (tool for modifying system config files)
* add user vagrant to group www-data


## productionbox

* setup apache vhost for project

### php

* php_ini set date.timezone
* TODO: php_ini set display_errors to Off
* TODO: php_ini set log_errors to On
* TODO: php_ini set error_log to /var/log/php.log

and for security

* TODO: php_ini set memory_limit=128M
* TODO: php_ini set max_execution_time=30
* TODO: php_ini set display_errors=off
* TODO: php_ini set expose_php=off
* TODO: php_ini set mail.log=/var/log/phpmails.log
* TODO: php_ini set disable_functions=exec
* php_ini set short_open_tag to Off

### apache

* TODO: setup apache security

## testbox

* install pear
* upgrade pear
* add pear channels php-unit and symfony
* install php-unit with pear channel

## developmentbox

* download composer
* test run composer
* install xdebug
* install rubygems1.8
* install nodejs
* install nodejs packages
* install own packages

## developmentbox_start

* TODO: add your .bash_aliases
* TODO: add ssh agent forwarding to use own key
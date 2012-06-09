# done

# basebox

* fix network (udev)
* update sources
* update puppet and facter

# setupbox

* install apache
* install php
* install php extensions php5-intl, php5-mysql, php5-libxm
* [TODO] install mongoDB
* [TODO] install php-modules (apc, mongo)
* install mysql server with user root, password vagrant
* install augeas (tool for modifying system config files)
* add user vagrant to group www-data


# productionbox

* php_ini set date.timezone
* php_ini set short_open_tag to Off
* [TODO] php_ini set display_errors to Off
* [TODO] php_ini set log_errors to On
* [TODO] php_ini set error_log to /var/log/php.log
* setup apache vhost for project

# testbox

* install pear
# done

# basebox

* fix network (udev)
* update sources
* update puppet and facter

# setupbox

* install apache
* install php
* install php extension php5-intl
* install php extension php5-mysql
* install mysql server with user root, password vagrant
* install augeas (tool for modifying system config files)
* add user vagrant to group www-data

# productionbox

* php_ini set date.timezone
* php_ini set short_open_tag to Off
* setup apache vhost for project

# testbox

*
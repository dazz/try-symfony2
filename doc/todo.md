# TODO

## Installing PHP Conﬁguration
### Default location op php ini

    /usr/local/lib/php.ini

Other common locations

    /etc/php/php.ini
    /etc/php5/cli/php.ini
    /etc/php5/apache2/php.ini

### Conﬁguration

    php -i | grep php.ini

    Conﬁguration File (php.ini) Path => /usr/local/php5/lib Loaded
    Conﬁguration File => /usr/local/php5-20110426-093151/lib/php.ini
    Scan this dir for additional .ini ﬁles => /usr/local/php5/php.d
    Additional .ini ﬁles parsed => /usr/local/php5/php.d/10- extension_dir.ini

    php -i | grep mongo /usr/local/php5/php.d/50-extension-mongo.ini, mongo mongo.allow_empty_keys => 0 => 0 mongo.allow_persistent => 1 => 1 mongo.auto_reconnect => 1 => 1 mongo.chunk_size => 262144 => 262144 mongo.cmd => $ => $ mongo.default_host => localhost => localhost mongo.default_port => 27017 => 27017

    php -m [PHP Modules] apc bcmath bz2 Core ctype curl date dom ereg
    php.ini extension_dir=/usr/lib/php/extensions/no-debug-non-zts-20090626 extension=apc.so extension=mongo.so
    php.ini php -i | grep extension_dir # extension_dir => /usr/local/php5/lib/php/extensions/no-debug-non-zts-20090626
    php.ini date.timezone=UTC
    display_errors = off
    log_errors = on
    error_log = /var/log/php.log

### Security

    memory_limit = 128M
    max_execution_time = 30
    display_errors = off
    expose_php = off
    mail.log = /var/log/phpmails.log
    disable_functions = exec
    allow_url_fopen = off

### File uploads on .htaccess

    php_value memory_limit 128M
    php_value max_ﬁle_uploads 20
    php_value max_input_time -1
    php_value post_max_size 8M
    php_value upload_max_ﬁlesize 2M
    php_value max_execution_time 0
    AllowOverride=All in Apache!

### Apache

    php_value date.timezone UTC
    php_ﬂag display_errors 1
    php_value memory_limit 128M
    php_value max_execution_time 0

### WebServer UserFix

Permissions issues with clear cache and uploads

    rm -rf app/cache/*
    rm -rf app/logs/*
    sudo chmod +a "www-data allow delete,write,append,file_inherit,directory_inherit" app/cache app/logs
    sudo chmod +a "`whoami` allow delete,write,append,file_inherit,directory_inherit" app/cache app/logs


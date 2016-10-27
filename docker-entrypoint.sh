#!/bin/bash
set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then #check whether the DB is initialized.
    echo 'Initializing database'
    mysql_install_db
    echo 'Database initialized'
    
    service mysql start
    /usr/bin/mysql -e 'CREATE DATABASE IF NOT EXISTS fod'
else
    service mysql start
fi

service memcached start
service beanstalkd start
service gunicorn start
service shibd start
service apache2 start

exec "$@"

#!/bin/bash
set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then #check whether the DB is initialized.
    echo 'Initializing database'
    mysql_install_db
    echo 'Database initialized'
    
    service mysql start
else
    service mysql start
fi

if [ ! -d "/var/lib/mysql/fod" ]; then #check whether the fod DB is initialized.
  /usr/bin/mysql -e 'CREATE DATABASE IF NOT EXISTS fod'
fi

service memcached start
service beanstalkd start
service gunicorn start
service shibd start
service apache2 start
service celeryd start
service exim4 start

exec "$@"

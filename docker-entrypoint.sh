#!/bin/bash
set -e

service mysql start
/usr/bin/mysql -e 'CREATE DATABASE IF NOT EXISTS fod'

service memcached start
service beanstalkd start
service gunicorn start
service shib2 start
service apache2 start

exec "$@"

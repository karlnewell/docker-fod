#!/bin/bash
set -e

service mysql start
/usr/bin/mysql -e 'CREATE DATABASE fod'

service memcached start
service beanstalkd start
service gunicorn start
service apache2 start

exec "$@"


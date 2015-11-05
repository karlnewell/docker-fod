#!/bin/bash
set -e

/usr/bin/mysql -e 'CREATE DATABASE fod'

service memcached start
service mysql start
service beanstalkd start
service gunicorn start
service apache2 start

exec "$@"


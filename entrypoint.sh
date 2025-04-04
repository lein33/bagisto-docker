#!/bin/sh

echo 'Running collecstatic...'
pwd
ls
cat .env
php artisan migrate --force
#php artisan serve --host=$HOST --port=80

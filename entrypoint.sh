#!/bin/sh

echo 'Running collecstatic...'
pwd
ls
git clone https://github.com/bagisto/bagisto.git 
cd bagisto
composer install
php artisan bagisto:install --skip-env-check --skip-admin-creation

php artisan migrate --force
php artisan storage:link 
php artisan db:seed --force || true 
php artisan config:cache 
php artisan route:cache 
php artisan view:cache 
php artisan optimize
#php artisan serve --host=$HOST --port=80

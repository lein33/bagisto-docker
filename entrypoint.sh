#!/bin/sh

echo 'Running collecstatic...'
pwd
ls
cat .env
php artisan bagisto:install --skip-env-check --skip-admin-creation
php artisan migrate --force
php artisan db:seed
#php artisan serve --host=$HOST --port=80

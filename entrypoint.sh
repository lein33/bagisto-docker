#!/bin/sh

echo 'Running collecstatic...'
pwd
ls
cat .env
php artisan serve --host=$HOST --port=80

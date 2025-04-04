#!/bin/sh

echo 'Running collecstatic...'
pwd
ls
cat .env
php artisan serve --host=bagisto-docker-production.up.railway.app --port=80

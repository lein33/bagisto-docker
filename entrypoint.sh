#!/bin/sh

echo 'Running collecstatic...'
pwd
ls /home
chmod -R 777 /var/www/html
mv * bagisto/
ls
echo 'run ss'
ls bagisto/

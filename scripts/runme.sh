#!/bin/sh

set -e
ARCHIVE_www=$PWD/www.tgz

cd /
rm -rf www/kncminion

tar xzf $ARCHIVE_www
echo 'WWW updated. No need to reboot! Just click <a href="/kncminion/">here</a> to continue...<br>'

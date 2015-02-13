#!/bin/bash

set -e
ARCHIVE_www=$PWD/www.tgz
ARCHIVE_etc=$PWD/etc.tgz

cd /
rm -rf www/kncminion

tar xzf $ARCHIVE_www
tar xzf $ARCHIVE_etc
echo 'WWW updated. No need to reboot! Just click <a href="/kncminion/">here</a> to continue...<br>'
/etc/init.d/lighttpd restart > /dev/null 2>&1

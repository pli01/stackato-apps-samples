#!/bin/bash

# extract DATABASE_URL into parts
php mediawiki-db.php > config.txt

cat <<EOF_USER >> config.txt
pass=changeme
user=admin
wikiname=MyWiki
EOF_USER

test -f config.txt && . config.txt
test -f LocalSettings.php && mv LocalSettings.php LocalSettings.php.old

# FIXME: initiate mysql connection, otherwise install.php failed
echo "show tables;" | mysql -h $dbserver -u $dbuser -p$dbpass $dbname
sleep 5
php maintenance/install.php --dbtype $dbtype --dbname $dbname --dbport $dbport --dbserver $dbserver --dbuser $dbuser --dbpass $dbpass --pass $pass --scriptpath "" --lang fr $wikiname $user


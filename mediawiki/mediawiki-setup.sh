#!/bin/bash
# extract DATABASE_URL and MEMCACHED_URL into parts

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

test -f LocalSettings.php || exit 1

# TODO
chmod 777 images

# Language (bug)
sed -i 's/$wgLanguageCode = "en";/$wgLanguageCode = "fr";/g' LocalSettings.php
# allow upload files
sed -i 's/$wgEnableUploads = false;/$wgEnableUploads = true;/g' LocalSettings.php

# Activate memcache and sessions
# user et pass pas utiliser en tcp mais en sasl
sed -i 's/^$wgMainCacheType .*/$wgMainCacheType = CACHE_MEMCACHED;/g' LocalSettings.php
#sed -i 's|^$wgMemCachedServers .*|$wgMemCachedServers = array("'$mcserver':'$mcport'/'$mcname'");|g' LocalSettings.php
sed -i 's|^$wgMemCachedServers .*|$wgMemCachedServers = array("'$mcserver':'$mcport'");|g' LocalSettings.php

cat << 'EOF_MEMCACHE' >> LocalSettings.php
$wgSessionsInObjectCache = true;
$wgSessionCacheType = CACHE_MEMCACHED;
EOF_MEMCACHE

# private wiki
cat << 'EOF' >> LocalSettings.php
# Disable reading by anonymous users
$wgGroupPermissions['*']['read'] = false;
# But allow them to access the login page or else there will be no way to log in!
# [You also might want to add access to "Main Page", "Wikipedia:Help", etc.)
$wgWhitelistRead = array ("Special:Userlogin");
# Disable anonymous editing
$wgGroupPermissions['*']['edit'] = false;
# Prevent new user registrations except by sysops
$wgGroupPermissions['*']['createaccount'] = false;
# Allow file uploads without restriction
$wgCheckFileExtensions = false;
$wgStrictFileExtensions = false;
$wgDefaultSkin = 'Vector';
# wfLoadSkin( 'Vector' );
$wgVectorUseSimpleSearch = true;
$wgVectorUseIconWatch = true;
EOF

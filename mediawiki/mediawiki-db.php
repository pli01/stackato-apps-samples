<?php
## Database settings
$_wgDBConnectionString = getenv('DATABASE_URL');
if (preg_match('%(.*?)://([^:]+):([^@]+)@([^:]+):(\d+)/(.*)%', $_wgDBConnectionString, $regs, PREG_OFFSET_CAPTURE)) {
 $wgDBtype = $regs[1][0];
 $wgDBuser = $regs[2][0];
 $wgDBpassword = $regs[3][0];
 $wgDBserver = $regs[4][0];
 $wgDBport = $regs[5][0];
 $wgDBname = $regs[6][0];
} else {
    die("Failed to parse DB connection string");
}
print "dbtype=$wgDBtype\n";
print "dbuser=$wgDBuser\n";
print "dbpass=$wgDBpassword\n";
print "dbserver=$wgDBserver\n";
print "dbport=$wgDBport\n";
print "dbname=$wgDBname\n";

## MemCache settings
$_wgMCConnectionString = getenv('MEMCACHED_URL');
#if (preg_match('%(.*?)://([^@]+)@([^:]+):([^:]+):(\d+)/(.*)%', $_wgMCConnectionString, $regs, PREG_OFFSET_CAPTURE)) {
if (preg_match('%([^:]+):(\d+)%', $_wgMCConnectionString, $regs, PREG_OFFSET_CAPTURE)) {
# $wgMCtype = $regs[1][0];
# $wgMCuser = $regs[2][0];
# $wgMCpassword = $regs[3][0];
# $wgMCserver = $regs[4][0];
# $wgMCport = $regs[5][0];
# $wgMCname = $regs[6][0];
 $wgMCtype = "";
 $wgMCuser = "";
 $wgMCpassword = "";
 $wgMCserver = "";
 $wgMCport = "";
 $wgMCname = "";

 $wgMCserver = $regs[1][0];
 $wgMCport = $regs[2][0];

} else {
    die("Failed to parse MemCached connection string");
}
print "mctype=$wgMCtype\n";
print "mcuser=$wgMCuser\n";
print "mcpass=$wgMCpassword\n";
print "mcserver=$wgMCserver\n";
print "mcport=$wgMCport\n";
print "mcname=$wgMCname\n";

?>

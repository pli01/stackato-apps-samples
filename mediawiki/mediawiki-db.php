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
?>

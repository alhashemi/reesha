#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/..";
use DB::Reesha;
use DateTime;
use Term::ReadKey;

my $schema = DB::Reesha->connect("dbi:SQLite:dbname=/home/yousef/reesha/reesha.db", "", "") or die "CONNECT ERROR: $!\n";

print "Username: ";
chomp(my $username = <STDIN>);

print "Name (nickname, full name, first name, whatever you prefer): ";
chomp(my $name = <STDIN>);

ReadMode('noecho');
print "Password: ";
chomp(my $password = <STDIN>);
ReadMode('restore');

print "\nEmail Address: ";
chomp(my $email = <STDIN>);

my $created = DateTime->now(time_zone => 'UTC'); 

my $row = $schema->populate('User', [
	[qw/username name password email_address confirmed created/],
	[$username, $name, $password, $email, 1, $created],
]);

print "\n\n*************** NEW USER INFO ***************\n";
printf("%21s%s\n", "ID: ", $row->[0]->id);
printf("%21s%s\n", "Username: ", $row->[0]->username);
printf("%21s%s\n", "Name: ", $row->[0]->name);
printf("%21s%s\n", "Password: ", $row->[0]->password);
printf("%21s%s\n", "Email Address: ", $row->[0]->email_address);
printf("%21s%s\n", "Confirmed: ", $row->[0]->confirmed ? 'TRUE' : 'FALSE');
printf("%21s%s\n", "Created: ", $row->[0]->created);
printf("%21s%s\n", "Last login time: ", "(null)");
printf("%21s%s\n", "Last login address: ", "(null)");
printf("%21s%s\n", "Suspended: ", $row->[0]->suspended ? 'TRUE' : 'FALSE');
printf("%21s%s\n", "Suspend notes: ", "(null)");

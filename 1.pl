#!/usr/bin/perl -w

use strict;
#use warnings;


use IO::Socket;
use URI::Find;
use URI::Find::Simple qw(list_uris);
use URI::Title qw(title);
use WWW::Mechanize;
use LWP::Protocol::socks;

# This setup works with I2p but for some reason only if I have my irc client open and connected to irc2p
my $server = "127.0.0.1";
my $nick = "aaajajaaaaahhaaaa";
my $login ="aaaaaaaaaa";
my $channel = "#testbot";

#my $socket;
# does socket creation,binding and listening at the specified port address.
my $socket = new IO::Socket::INET (
	PeerAddr => $server,
	PeerPort => '6668',
	Proto => 'tcp'
) or die "Error in socket creation, socket could be in use: $!\n";
 
# Add second nick later for if nick is reserved
# add password to authenticate nick 
# Make nice data structure to keep this data in perhaps a hash called bot

# Need to add method for if nick is in use what todo.
# Also need to be able to handle random disconnects and connect again and
# authenticate for nick to nickserv again
sub setNick {
print $socket "NICK $nick\r\n";
print $socket "USER $login 8 *:Sample IRC Bot In Perl\r\n";
} 

sub connectCheckNick {
# According to this link:
# http://oreilly.com/pub/h/1964
# Read lines from server until it tells us we have connected
while (my $input = <$socket>) {
	# Check numerical responses from the server
	if ($input =~ /004/) {
		# Means we are logged in
		last;
	}
	elsif ($input =~ /433/) {
		die "Nickname is in use";
		# // Later make it switch to second nickname
	}
}
}

sub joinChan {
# Now we can join a channel!
#   Write function to do this
print $socket "JOIN $channel\r\n";
 
}

sub getStuffOverTor {
my $url = $_[0];
my $mech = WWW::Mechanize->new(timeout => 60*5);
$mech->proxy(['http','https'],'socks://localhost:9050');
$mech->get($url);
my $title = $mech->title();
# Up to about here.
return $title;
} 

sub checkForURL {          
# Put this in a sub later
my @list = list_uris(@_);
my $how_many_found = @list;
# If this is an .i2p address use method  localhost:4444
# else use tor socks proxy 
# both .onion and normal urls are going to be fetched using tor.
# So no need to check if a url is an .onion url
if ($how_many_found > 0) {

# Put this shit in a method too!
#my $title = title($list[0]);
my $url = $list[0];
# End of function
# Return $how_many_found
# and return $url
# return ($how_many_found,$url);
#
# later in code
# if ($how_many_found > 0) {
# 

my $is_eepsite = ($url =~ /\.(i2p.?)\b/i); # Put this in method later
if ($is_eepsite) {
	print "We have an eepsite: $url\n";
	# Call some method to get title of eepsite.
}
else {
my $title = getStuffOverTor($url);

# Is this an eepsite. If it is do something,else just use socks connection
# to tor on localhost and we assume it is a regular website or .onion


# If the refactoring of this code works. Then make this sub return
# the url and the title and put these print statements in seperate sub.
print $socket "PRIVMSG $channel $url\n";
print $socket "PRIVMSG $channel Title: $title\n";
}	  
}		
}


&setNick;

&connectCheckNick;

&joinChan;

# Keep reading the lines from the server respond to ping with pong
while (my $input = <$socket>) {
	chop $input;
	if ($input =~ /^PING(.*)$/i) {
		#Respond to ping
		print $socket "PONG $1\r\n";
	}
	# Everything happens here.
else { 
# Do something
&checkForURL($input);
	}
}


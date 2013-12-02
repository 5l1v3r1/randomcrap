#!/usr/bin/perl -w

use strict;
#use warnings;


use IO::Socket;

# Add second nick later for if nick is reserved
# add password to authenticate nick 
# Make nice data structure to keep this data in perhaps a hash called bot
#
# my %bot = (
#  server => "irc.freenode.net",
#  nick => "aaaaaaaa",
#  channel => "#blah"
#  )
#
my $server = "irc.freenode.net";
my $nick = "aaaaaaaaaa";
my $login ="aaaaaaaaaa";
my $channel = "#testbot";

#my $socket;
# does socket creation,binding and listening at the specified port address.
my $socket = new IO::Socket::INET (
	PeerAddr => $server,
	PeerPort => '6667',
	Proto => 'tcp'
) or die "Error in socket creation, socket could be in use: $!\n";

# Write function to do this
print $socket "NICK $nick\r\n";
print $socket "USER $login 8 *:Sample IRC Bot In Perl\r\n";

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
# Now we can join a channel!
#   Write function to do this
print $socket "JOIN $channel\r\n";

# Keep reading the lines from the server respond to ping with pong
while (my $input = <$socket>) {
	chop $input;
	if ($input =~ /^PING(.*)$/i) {
		#Respond to ping
		print $socket "PONG $1\r\n";
	}
	else {
		#Print the raw line received by bot
		print "$input\n";

	}
}

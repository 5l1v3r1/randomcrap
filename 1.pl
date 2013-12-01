#!/usr/bin/perl

#use strict;
#use warnings;

# IRC Bot for I2P
#
#
use IO::Socket::INET;

# Flush after every write
$| = 1;

my ($socket,$client_socket);

# Creating object interface of IO::Socket::INET which internally
# does socket creation,binding and listening at the specified port address.
$socket = new IO::Socket::INET (
	Localhost => 'irc.freenode.net',
	Localport => '6668',
	Proto => 'tcp',
	Listen => 5,
	Reuse => 1
) or die "Error in socket creation, socket could be in use: $!\n";


while (1) {
#print "TCP Connection success!\n";


# This is I2P,lets let it sleep for  200 before printing out data read
# from the server
#sleep(200);
# Read socket data sent by server



my $data = "";
#$data = <$socket>;
# We can read data from socket with recv() in IO::Socket::INET

$socket->recv($data,1024);
print "Received from server : $data\n";

# Write to server and set nick etc. 
# Lookup format for doing this.
#
#
# Try kyk na hoe python code dit doen met while loop
# en consider om

#sleep(10);
$socket->close();

}

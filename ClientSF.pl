!/usr/bin/perl -w

use strict;
use sigtrap;
use Socket;

socket(Server,PF_INET,SOCK_STREAM, getprotobyname('tcp'));

$internet_addr = inet_aton($remote_host)
	or die "Couldn't convert $remote_host into an Internet address: $!\n";
$paddr = sockaddr_in($remote_port, $internet_addr);

connect(Server, $paddr)
	or die "Couldn't connect to $remote_host:$remote_port:$!\n";

select((select(Server), $| = 1)[0]);

print Server "Why don't you call me anymore?\n";

$answer = <Server>;

$other_end = getpeername(Client)
	or die "Couldn't identify other end: $!\n";
($port, $iaddr) = unpack_sockaddr_in($other_end);
$actual_ip = inet_ntoa($iaddr);
$claimed_hostname = gethostbyaddr($iaddr, AF_INET);

close(Server);

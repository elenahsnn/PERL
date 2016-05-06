use strict;
use Socket;

socket(Server, PF_INET, SOCK_STREAM, getprotobyname('tcp'));

setsockopt(Server, SOL_SOCKET, SO_REUSEADDR, 1);

$my_addr = sockaddr_in($server_port,INADDR_ANY);
bind(Server, $my_addr)
	or die "Can't bind socket to port $server_port:$!\n";

listen(Server, SOMAXCONN)
	or die "Couldn't listen on port $server_port:$!\n";

REQUEST:
while(accept(Client, Server)){
	if($kidpid = fork){
		close Client;
		next Request;
	}
	defined($kidpid)
		or die "Cannot fork: $!";
	close Server;

	select(Client);
	$| = 1;

	$input = <Client>;
	print Client "output\n";

	open(STDIN, "<<&Client") 
		or die "can't dup client: $!";
	open(STDOUT, ">&Client")
		or die "can't dup client: $!";
	open(STDERR, ">&Client")
		or die "can't dup client: $!";

system("bc -1");
print "done\n";

close Client;
exit;
}

close(Server);

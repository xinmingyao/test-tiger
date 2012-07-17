#!/usr/bin/env perl -w

use strict;
use Test::More;
use Cache::Memcached;
use IO::Socket::INET;

`rm -rf ../dev/dev1/data/*`;
`rm -rf ../dev/dev2/data/*`;
`rm -rf ../dev/dev3/data/*`;
`../dev/dev1/bin/tiger start `;

`../dev/dev3/bin/tiger start `;
unless ($^V) {
    plan skip_all => "This test requires perl 5.6.0+\n";
    exit 0;
}

plan tests => 202;
my $testaddr = "127.0.0.1:11211";
my $testaddr2 = "127.0.0.1:11212";
my $testaddr3 = "127.0.0.1:11213";
my $msock = IO::Socket::INET->new(PeerAddr => $testaddr,
                                  Timeout  => 3);

my $memd = Cache::Memcached->new({
    servers   => [ $testaddr ],
});

my $memd3 = Cache::Memcached->new({
    servers   => [ $testaddr3 ],
});
isa_ok($memd, 'Cache::Memcached');
isa_ok($memd3, 'Cache::Memcached');

my $memcached_version;
my $i;
sleep(10);
for($i=1;$i<100;$i++){
   $memd->add("$i","$i");	
}
#start node2
`../dev/dev2/bin/tiger start `;
my $memd2 = Cache::Memcached->new({
    servers   => [ $testaddr2 ],
});
isa_ok($memd2, 'Cache::Memcached');
for($i=100;$i<200;$i++){
   $memd->add("$i","$i");	
}
sleep(10);
for($i=1;$i<200;$i++){
	is($memd2->get("$i"), "$i", "node follow join get $i");
}


`../dev/dev1/bin/tiger stop `;
`../dev/dev2/bin/tiger stop `;
`../dev/dev3/bin/tiger stop `;

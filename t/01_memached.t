#!/usr/bin/env perl -w

use strict;
use Test::More;
use Cache::Memcached;
use IO::Socket::INET;

unless ($^V) {
    plan skip_all => "This test requires perl 5.6.0+\n";
    exit 0;
}

my $testaddr = "127.0.0.1:11211";
my $testaddr2 = "127.0.0.1:11212";
my $testaddr3 = "127.0.0.1:11213";
my $msock = IO::Socket::INET->new(PeerAddr => $testaddr,
                                  Timeout  => 3);
if ($msock) {
    plan tests => 11;
} else {
    plan skip_all => "No memcached instance running at $testaddr\n";
    exit 0;
}

my $memd = Cache::Memcached->new({
    servers   => [ $testaddr ],
    namespace => "Cache::Memcached::t/$$/" . (time() % 100) . "/",
});

my $memd2 = Cache::Memcached->new({
    servers   => [ $testaddr2 ],
    namespace => "Cache::Memcached::t/$$/" . (time() % 100) . "/",
});
my $memd3 = Cache::Memcached->new({
    servers   => [ $testaddr3 ],
    namespace => "Cache::Memcached::t/$$/" . (time() % 100) . "/",
});
isa_ok($memd, 'Cache::Memcached');
isa_ok($memd2, 'Cache::Memcached');
isa_ok($memd3, 'Cache::Memcached');

my $memcached_version;
ok($memd->add("key2", "val2"), "node 1 add key2 as val2");
is($memd->get("key2"), "val2", "node 1 get key2 is val2");
is($memd2->get("key2"), "val2", "node 2 get key2 is val2");
is($memd3->get("key2"), "val2", "node 3 get key2 is val2");
ok($memd3->delete("key2"), "node 3 delete key2");
ok(! $memd->get("key2"), "node 1 get key2 properly failed");
ok(! $memd2->get("key2"), "node2 get key2 properly failed");
ok(! $memd3->get("key2"), "node 3 get key2 properly failed");


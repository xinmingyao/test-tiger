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
my $msock = IO::Socket::INET->new(PeerAddr => $testaddr,
                                  Timeout  => 3);
if ($msock) {
    plan tests => 5;
} else {
    plan skip_all => "No memcached instance running at $testaddr\n";
    exit 0;
}

my $memd = Cache::Memcached->new({
    servers   => [ $testaddr ],
    namespace => "Cache::Memcached::t/$$/" . (time() % 100) . "/",
});

isa_ok($memd, 'Cache::Memcached');

my $memcached_version;



ok($memd->add("key2", "val2"), "add key2 as val2");
is($memd->get("key2"), "val2", "get key2 is val2");
ok($memd->delete("key1"), "delete key1");
ok(! $memd->get("key1"), "get key1 properly failed");


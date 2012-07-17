#!/usr/bin/perl
use Test::Base;
use lib 'lib';
use Redis;
use Redis::Hash;

my $r = Redis->new(server => 'localhost:6379');
my $r2 = Redis->new(server => 'localhost:6380');
my $r3 = Redis->new(server => 'localhost:6381');
$r->del("a");
$r->set("a","aa");
sub n1 { $r->get(shift)}
sub n2 { $r2->get(shift)}
sub n3 { $r3->get(shift)}
sub myfilter {
	$r2->del("a");
	}
sub del {
	$r->get(shift);
}
run_is 'input' => 'expected';

__END__

=== node1 get 
--- input chomp n1
a
--- expected chomp
aa

=== node2 get
--- input chomp n2
a
--- expected chomp
aa
=== node3 get
--- input chomp n3
a
--- expected chomp
aa



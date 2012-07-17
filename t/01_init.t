#!/usr/bin/env perl -w

use strict;
use Test::More;
use Cache::Memcached;
`rm -rf ../dev/dev1/data/*`;
`rm -rf ../dev/dev2/data/*`;
`rm -rf ../dev/dev3/data/*`;
`../dev/dev1/bin/tiger start `;
`../dev/dev2/bin/tiger start `;
`../dev/dev3/bin/tiger start `;

plan tests =>1;
is(1,1,"test");
sleep(3);

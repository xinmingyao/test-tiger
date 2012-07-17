#!/usr/bin/env perl -w

use strict;
use Test::More;
use Cache::Memcached;
`../dev/dev1/bin/tiger stop `;
`../dev/dev2/bin/tiger stop `;
`../dev/dev3/bin/tiger stop `;

plan tests =>1;
is(1,1,"test");


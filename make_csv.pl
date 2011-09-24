#!/usr/bin/env perl

use strict;
use warnings;

use CSVHack;

my $filename   = '13tokyo.csv';
my $backup_dir = './back/';
my $tmp_dir    = './tmp/';

my $csv = CSVHack->new(
    {
        filename   => $filename,
        backup_dir => $backup_dir,
        tmp_dir    => $tmp_dir,
    }
);

my $new_row = [ 0000, 14, 11111 ];

$csv->add_row($new_row);

$csv->backup->save;

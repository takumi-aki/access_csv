#!/usr/bin/env perl

use strict;
use warnings;

use lib "$ENV{HOME}/perl-utils/";

use Text::CSV;
use IO::File;
use File::Copy::Recursive qw/rcopy rmove/;
use autodie qw/:default rcopy rmove/;
use utf8;

my $filename   = '13tokyo.csv';
my $backup_dir = './back/';
my $tmp_dir    = './tmp/';

my $read_csv = Text::CSV->new(
    {
        auto_diag => 1,
        binary    => 1,
    }
);

open( my $read_fh, '<:encoding(cp932)', $filename );

my @file;
while ( my $row = $read_csv->getline($read_fh) ) {
    push @file, $row;
}

close $ifh;

# backup
rcopy( $filename, $backup_dir );

my $new_row = [ 0000, 14, 11111 ];

push @file, $new_row;

my $write_csv = Text::CSV->new(
    {
        auto_diag => 1,
        binary    => 1,
        eol       => "\r\n",
    }
);

open( my $write_fh, '>:encoding(cp932)', $filename );

$write_csv->print( $write_fh, $_ ) for @file;

package CSVHack;

use strict;
use warnings;

use utf8;
use autodie qw/ :default rcopy /;
use Text::CSV;
use IO::File;
use File::Copy::Recursive qw/ rcopy /;
use base qw/ Class::Accessor::Fast /;

__PACKAGE__->mk_accessors(qw/ filename backup_dir tmp_dir data /);

sub new {
    my ( $class, $args ) = @_;

    my $csv = Text::CSV->new(
        {
            auto_diag => 1,
            binary    => 1,
        }
    );

    my $self = {
        filename   => $args->{filename},
        backup_dir => $args->{backup_dir},
        tmp_dir    => $args->{tmp_dir},
        data       => [],
    };

    bless $self, $class;

    open( my $read_fh, '<:encoding(cp932)', $self->filename );

    while ( my $row = $csv->getline($read_fh) ) {
        push @{ $self->{data} }, $row;
    }

    return $self;
}

sub backup {
    my $self = shift;

    rcopy( $self->filename, $self->backup_dir );

    return $self;
}

sub add_row {
    my $self = shift;

    my $array_ref = ref $_[0] eq 'ARRAY' ? $_[0] : [@_];

    push @{ $self->data }, $array_ref;

    return $self;
}

sub save {
    my $self = shift;

    my $csv = Text::CSV->new(
        {
            auto_diag => 1,
            binary    => 1,
            eol       => "\r\n",
        }
    );

    open( my $fh, '>:encoding(cp932)', $self->filename );

    $csv->print( $fh, $_ ) for @{ $self->data };

    close $fh;

    return $self;
}

1;

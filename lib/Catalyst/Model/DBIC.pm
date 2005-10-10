package Catalyst::Model::DBIC;

use strict;
use base 'Catalyst::Base';
use NEXT;
use DBIx::Class::Loader;

our $VERSION = '0.10';

__PACKAGE__->mk_accessors('loader');

=head1 NAME

Catalyst::Model::DBIC - DBIC Model Class

=head1 SYNOPSIS

    # use the helper
    create model DBIC DBIC dsn user password

    # lib/MyApp/Model/DBIC.pm
    package MyApp::Model::DBIC;

    use base 'Catalyst::Model::DBIC';

    __PACKAGE__->config(
        dsn           => 'dbi:Pg:dbname=myapp',
        password      => '',
        user          => 'postgres',
        options       => { AutoCommit => 1 },
        relationships => 1
    );

    1;

    # As object method
    $c->comp('MyApp::Model::DBIC::Table')->search(...);

    # As class method
    MyApp::Model::DBIC::Table->search(...);

=head1 DESCRIPTION

This is the C<DBIx::Class> model class. It's built on top of 
C<DBIx::Class::Loader>.

=head2 new

Initializes DBIx::Class::Loader and loads classes using the class
config. Also attempts to borg all the classes.

=cut

sub new {
    my ( $self, $c ) = @_;
    $self = $self->NEXT::new($c);
    $self->{namespace}               ||= ref $self;
    $self->{additional_base_classes} ||= ();
    push @{ $self->{additional_base_classes} }, ref $self;
    eval { $self->loader( DBIx::Class::Loader->new(%$self) ) };
    if ($@) { $c->log->debug(qq/Couldn't load tables "$@"/) if $c->debug }
    else {
        $c->log->debug(
            'Loaded tables "' . join( ' ', $self->loader->tables ) . '"' )
          if $c->debug;
    }
    for my $class ( $self->loader->classes ) {
        $c->components->{$class} ||= bless {%$self}, $class;
        no strict 'refs';
        *{"$class\::new"} = sub { bless {%$self}, $class };
    }
    return $self;
}

=head1 SEE ALSO

L<Catalyst>, L<DBIx::Class> L<DBIx::Class::Loader>

=head1 AUTHOR

Sebastian Riedel, C<sri@cpan.org>

=head1 COPYRIGHT

This program is free software, you can redistribute it and/or modify it 
under the same terms as Perl itself.

=cut

1;

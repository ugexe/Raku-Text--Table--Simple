use v6;
use Test;
plan 1;
use Text::Table::Simple;


# Basic table testing using defaults
{
    my @columns = <id name email>;
    my @rows   = (
        <1 "John Doe" johndoe@cpan.org>,
        [2,'Jane Doe','mrsjanedoe@hushmail.com'],
    );

    my $expected = 
          " id |   name   |          email         \n"
        ~ "  1 | John Doe |        johndoe@cpan.org\n"
        ~ "  2 | Jane Doe | mrsjanedoe@hushmail.com";

    my $table_text = @rows.table(columns => \@columns, rows => \@rows);

    ok $table_text, $expected, 'Basic table matched.';
}


done;

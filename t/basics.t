use v6;
use Test;
plan 3;
use Text::Table::Simple;

my @columns = ['id','name','email'];
my @rows   = (
    [1,"John Doe",'johndoe@cpan.org'],
    [2,'Jane Doe','mrsjanedoe@hushmail.com'],
);

# Determine max column width
{
    my @widths = _get_column_widths(@columns,@rows);
    is @widths[0], 2,  'Column 1 max width of 2';
    is @widths[1], 8,  'Column 2 max width of 8';
    is @widths[2], 23, 'Column 3 max width of 23';
}

# Test formatted header output
{
    my @expected = (
        'O----O------O-------O',
        '| id | name | email |',
        'O----O------O-------O',
    );

    my @widths = _get_column_widths(@columns);
    my @output = _build_header(\@widths, \@columns);

    is_deeply @output, @expected, 'Create a header'
}



done;

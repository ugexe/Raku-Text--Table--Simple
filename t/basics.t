use v6;
use Test;
plan 8;
use Text::Table::Simple;

my @columns = ['id','name','email'];
my @rows   = (
    [1,"John Doe",'johndoe@cpan.org'],
    [2,'Jane Doe','mrsjanedoe@hushmail.com'],
);



# Determine max column width
{
    my @widths = _get_column_widths(@columns,@rows);
    is @widths[0], 2,  'Column 1 max width of 2';  # id
    is @widths[1], 8,  'Column 2 max width of 8';  # John Doe
    is @widths[2], 23, 'Column 3 max width of 23'; # mrsjanedoe@hushmail.com
}



# Test formatted header output
{
    my @expected = (
        'O----O------O-------O',
        '| id | name | email |',
    #   'O----O------O-------O',
    );

    my @widths = _get_column_widths(@columns);
    my @output = _build_header(@widths, @columns);

    is_deeply @output, @expected, 'Create a header'
}



# Test formatted multi-row header output (2nd longer)
{
    my @columns2 = @columns.map({ [@$_.map({ $_ ~ '2' })] });
    my @expected = (
        'O-----O-------O--------O',
        '| id  | name  | email  |',
        '| id2 | name2 | email2 |',
    #   'O-----O-------O--------O',
    );

    # Test when first row labels are shorter than others
    {
        my @widths = _get_column_widths(@columns,@columns2);
        my @output = _build_header( @widths, (@columns, @columns2) );

        is_deeply @output, @expected, 'Multi row header with first header row cells as the longest';
    }

    # Test when last row labels are shorter than others
    {
        my @widths = _get_column_widths( (@columns2,@columns) );
        my @new_expected := @expected;
        (@new_expected[1], @new_expected[2]) = (@new_expected[2], @new_expected[1]);
        my @output = _build_header( @widths, (@columns2, @columns) );

        is_deeply @output, @expected, 'Multi row header with last header row cells as the longest';
    }
}



# Test formatted table
{
    my @expected = (
        'O----O----------O-------------------------O',
        '| id | name     | email                   |',
        '|-----------------------------------------|',
        '| 1  | John Doe | johndoe@cpan.org        |',
        '| 2  | Jane Doe | mrsjanedoe@hushmail.com |',
        'O----O----------O-------------------------O',
    );

    my @output = _build_table(@columns, @rows);

    is _build_table(@columns,@rows), lol2table(@columns,@rows), 'Public api matches private api';
    is_deeply @output, @expected, 'Create a table (header + body)'
}



done;

# NAME

Text::Table::Simple - Create basic tables from a two dimensional array.

# SYNOPSIS

    use Text::Table::Simple;
    my @columns = <id name email>;
    my @rows   = (
        <1 "John Doe" johndoe@cpan.org>,
        [2,'Jane Doe','mrsjanedoe@hushmail.com'],
    );

    say @rows.table(columns => \@columns, rows => \@rows);

    # the same as:

    use Text::Table::Simple;
    my @column = <id name email>;
    my @rows   = (
        <1 "John Doe" johndoe@cpan.org>,
        [2,'Jane Doe','mrsjanedoe@hushmail.com'],
    );

    my %format = { # default formatting options
        row_separator        => '-',
        column_separator     => '|',
        corner_marker        => '+',
        header_row_separator => '=',
        header_corner_marker => 'O',
    }

    say @rows.table(columns => \@columns, rows => \@rows, format => \%format);


# DESCRIPTION

Output table header, rows, and columns. Take showing your Benchmark output for example:

    use Text::Levenshtein::Damerau; 
    use Text::Levenshtein;
    use Benchmark;

    my %results = timethese($runs, {
        'dld     ' => sub { Text::Levenshtein::Damerau::{"&dld($str1,$str2)"} },
        'ld      ' => sub { Text::Levenshtein::Damerau::{"&ld($str1,$str2)"}  },
        'distance' => sub { Text::Levenshtein::{"&distance($str1,$str2)"}     },
    });

    my @columns = <description start end diff avg>;
    my @rows    = map { .unshift(%results{$_}) } %results.keys;


# METHODS

## table

Arguments: \@rows 2 dimentional array ref 
$rows: 2 dimentional array ref
- _OPTIONAL argument_ \@columns: Header column names 
- _OPTIONAL argument_ \%format: Formatting options 

Prints out the 2D array as a table.

    @some_array.table(rows =>)

# BUGS

Please report bugs to:

[https://github.com/ugexe/Perl6-Text--Table--Simple/issues](https://github.com/ugexe/Perl6-Text--Table--Simple/issues)

# AUTHOR

Nick Logan <`ugexe@cpan.org`\>

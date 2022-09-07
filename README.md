## Text::Table::Simple

Create basic tables from a two dimensional array

## Synopsis

    use Text::Table::Simple;

    my @columns = <id name email>;
    my @rows    = (
        [1,"John Doe",'johndoe@cpan.org'],
        [2,'Jane Doe','mrsjanedoe@hushmail.com'],
    );

    my @table = lol2table(@columns,@rows);
    .say for @table;

    # O----O----------O-------------------------O
    # | id | name     | email                   |
    # O====O==========O=========================O
    # | 1  | John Doe | johndoe@cpan.org        |
    # | 2  | Jane Doe | mrsjanedoe@hushmail.com |
    # -------------------------------------------

## Exports

#### lol2table(@body, *%options --> Str @rows)

#### lol2table(@header, @body, @footer?, *%options --> Str @rows)

Create a an array of strings that can be printed line by line to create a table view of the data.

    > my @cols = <XXX XXXX>;
    > my @rows = ([1,2],[3,4]);
    > say lol2table(@cols, @rows).join("\n");

    O-----O------O
    | XXX | XXXX |
    O=====O======O
    | 1   | 2    |
    | 3   | 4    |
    --------------

##### Options

    # default values
    %options = %(
        rows => {
            column_separator     => '|',
            corner_marker        => '-',
            bottom_border        => '-',
        },
        headers => {
            top_border           => '-',
            column_separator     => '|',
            corner_marker        => 'O',
            bottom_border        => '=',
        },
        footers => {
            column_separator     => 'I',
            corner_marker        => '%',
            bottom_border        => '*',
        },
    );

You can replace any of the default options by passing in a replacement.
C<corner_marker> is used when more specific corner markers are not set.

    > my %options =
        rows => {
            column_separator           => '│',
            bottom_left_corner_marker  => '└',
            bottom_right_corner_marker => '┘',
            bottom_corner_marker       => '┴',
            bottom_border              => '─',
        },
        headers => {
            top_border                 => '═',
            column_separator           => '│',
            top_corner_marker          => '╤',
            top_left_corner_marker     => '╒',
            top_right_corner_marker    => '╕',
            bottom_left_corner_marker  => '╞',
            bottom_right_corner_marker => '╡',
            bottom_corner_marker       => '╪',
            bottom_border              => '═',
        };
    > my @columns = <id name email>;
    > my @rows    = (
        [1,"John Doe",'johndoe@cpan.org'],
        [2,'Jane Doe','mrsjanedoe@hushmail.com'],
    );

    > .put for lol2table(@columns, @rows, |%options);

    ╒════╤══════════╤═════════════════════════╕
    │ id │ name     │ email                   │
    ╞════╪══════════╪═════════════════════════╡
    │ 1  │ John Doe │ johndoe@cpan.org        │
    │ 2  │ Jane Doe │ mrsjanedoe@hushmail.com │
    └────┴──────────┴─────────────────────────┘

## Examples

Showing your Benchmark output:

    use Text::Table::Simple;

    use Text::Levenshtein::Damerau; 
    use Benchmark;

    my $str1 = "lsd";
    my $str2 = "lds";

    my %results = timethese(1000, {
        'dld' => sub { Text::Levenshtein::Damerau::{"&dld($str1,$str2)"} },
        'ld ' => sub { Text::Levenshtein::Damerau::{"&ld($str1,$str2)"}  },
    });

    my @headers = ['func','start','end','diff','avg'];
    my @rows    = %results.map: {.key, .value.Slip}
    my @table   = lol2table(@headers,@rows);

    .say for @table;

Also see the [examples](https://github.com/ugexe/Raku-Text--Table--Simple/tree/main/examples) directory.

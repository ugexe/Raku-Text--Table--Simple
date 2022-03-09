use Text::Table::Simple;

my %options =
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

my @columns = <id name email>;
my @rows    = (
    [1,"John Doe",'johndoe@cpan.org'],
    [2,'Jane Doe','mrsjanedoe@hushmail.com'],
);

my @table = lol2table(@columns, @rows, |%options);
.put for @table;

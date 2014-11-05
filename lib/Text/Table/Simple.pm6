use v6;
class Text::Table::Simple;

has Str $.row_separator        is rw;
has Str $.column_separator     is rw;
has Str $.corner_marker        is rw;
has Str $.header_row_separator is rw;
has Str $.header_corner_marker is rw;
has Str $.footer_row_separator is rw;
has Str $.footer_corner_marker is rw;

# TODO
# 1. Allow users to somehow insert separators in arbitrary locations 
# Maybe like Text::Table::Simple.insert_line() in an array as a callback to insert the 
# appropriate number of separators to complete the row after the entire table has been 
# scanned?
#
# 2. Handling word wrapping/terminal widths properly

# Change options format:
# {
#   row_separator    = '-';
#   column_separator = '|';
#   corner_marker    = '+';
#   header => {
#     row_separator    = '=';
#     column_separator = '|';
#     corner_marker    = 'O';
#   }
#   footer => {
#     row_separator    = '~';
#     column_separator = 'I';
#     corner_marker    = '%';
#   }
# }

constant %defaults = {
  row_separator    => '-',
  column_separator => '|',
  corner_marker    => '+',
  header => {
    row_separator    => '=',
    column_separator => '|',
    corner_marker    => 'O',
  },
  footer => {
    row_separator    => '~',
    column_separator => 'I',
    corner_marker    => '%',
  },
};

submethod BUILD (:$!row_separator = '-', :$!column_separator = '|', :$!corner_marker = '+', 
    :$!header_row_separator = '=', :$!header_corner_marker = 'O',
    :$!footer_row_separator = '=', :$!footer_corner_marker = 'O' ) {
    # nothing to do here, the signature binding
    # does all the work for us.    
}


#method table (Array of Str :@rows, Array of Str :@columns?, Array of Str :@footers?) returns Array of Str is export {
#}

sub _build_table (@header_rows,@body_rows?,@footer_rows?) is export {
    my @widths = _get_column_widths(@header_rows,@body_rows);  
    return _build_header(@widths,@header_rows), _build_body(@widths,@body_rows), _build_footer(@widths);
}

sub _build_header (@widths, @columns, %options = %defaults) is export {
    my Str @processed;
    my $sep  = '-';
    my $mark = 'O';
    my $csep = '|';

    # Top border
    @processed.push( $mark ~ $sep ~ @widths.map({ $sep x $_ }).join("$sep$mark$sep") ~ $sep ~ $mark );

    @processed.push( _row2str(@widths, @$_) ) for @columns; # TODO: pass %options

    return @processed;
}

sub _build_body (@widths, @rows, %options = %defaults) is export {
    my Str @processed;
    my $sep  = '-';
    my $mark = 'O';
    my $csep = '|';

    # Top border
    @processed.push( $csep ~ $sep ~ @widths.map({ $sep x $_ }).join("$sep$sep$sep") ~ $sep ~ $csep );

    @processed.push( _row2str(@widths, @$_) ) for @rows; # TODO: pass %options

    return @processed;
}

# For now just adds the bottom border although you should be able to pass the result of
# _build_header or _build_body so you can format it without or with row separators
sub _build_footer (@widths,*@rows) {
    my @processed;
    my $sep  = '-';
    my $mark = 'O';
    my $csep = '|';

    @processed.push( $mark ~ $sep ~ @widths.map({ $sep x $_ }).join("$sep$mark$sep") ~ $sep ~ $mark );
}

# returns formatted row
sub _row2str (@widths, @cells, %options = %defaults) {
    my $sep  = '-';
    my $mark = 'O';
    my $csep = '|';

    # sprintf format
    my $format = "$csep " ~ join(" $csep ", @widths.map({"%-{$_}s"}) ) ~ " $csep";
    return sprintf( $format, @cells.map({ $_ // '' }) ); 
}


method _build_body {

}

method _build_footer {

}

# Iterate over ([1,2,3],[2,3,4,5],[33,4,3,2]) to find the longest string in each column
sub _get_column_widths ( *@rows ) is export {
    return (0..@rows[0].elems-1).map( -> $col { reduce { max($^a, $^b)}, map { .chars }, @rows[*;$col]; } );
}

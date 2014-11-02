use v6;
class Text::Table::Simple;

has Str $.row_separator        is rw;
has Str $.column_separator     is rw;
has Str $.corner_marker        is rw;
has Str $.header_row_separator is rw;
has Str $.header_corner_marker is rw;

submethod BUILD (:$!row_separator = '-', :$!column_separator = '|', 
    :$!corner_marker = '+', :$!header_row_separator = '=', :$!header_corner_marker = 'O' ) {
    # nothing to do here, the signature binding
    # does all the work for us.    
}

sub table(Array of Str @columns, Array of Str @rows) returns Array of Str is export {

}


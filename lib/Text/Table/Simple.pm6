use v6;
class Text::Table::Simple;

has Str $.row_separator        is rw;
has Str $.column_separator     is rw;
has Str $.corner_marker        is rw;
has Str $.header_row_separator is rw;
has Str $.header_corner_marker is rw;
has Str $.footer_row_separator is rw;
has Str $.footer_corner_marker is rw;

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

submethod BUILD (:$!row_separator = '-', :$!column_separator = '|', :$!corner_marker = '+', 
    :$!header_row_separator = '=', :$!header_corner_marker = 'O',
    :$!footer_row_separator = '=', :$!footer_corner_marker = 'O' ) {
    # nothing to do here, the signature binding
    # does all the work for us.    
}


sub table(Array of Str :@rows, Array of Str :@columns?, Array of Str :@footers?) returns Array of Str is export {

}


use v6.c;
unit module Text::Table::Simple;

my %defaults is Map =
    rows => Map.new(
        'column_separator' , '|',
        'corner_marker'    , '-',
        'bottom_border'    , '-',
    ),
    headers => Map.new(
        'top_border'       , '-',
        'column_separator' , '|',
        'corner_marker'    , 'O',
        'bottom_border'    , '=',
    ),
    footers => Map.new(
        'column_separator' , 'I',
        'corner_marker'    , '%',
        'bottom_border'    , '*',
    ),
;


proto sub lol2table(|) {*}
multi sub lol2table (@body_rows, *%options) {
    # no header or footer, just body
    _build_table(:@body_rows, |%options);
}
multi sub lol2table (@header_rows, @body_rows, *%options) {
    # header and body, no footer
    _build_table(:@header_rows, :@body_rows, |%options);
}
multi sub lol2table (@header_rows, @body_rows, @footer_rows, *%options) is export {
    # header, body, and footer
    _build_table(:@header_rows, :@body_rows, :@footer_rows, |%options);
}

sub _build_table (:@header_rows, :@body_rows is raw, :@footer_rows, *%o) is export {
    my %options = _build_options(%o);
    my @widths  = _get_column_widths(@header_rows, |@body_rows);
    my @rows    = flat  _build_header(@widths, @header_rows, |%options),
                        _build_body(@widths, |@body_rows, |%options),
                        (_build_footer(@widths, @footer_rows, |%options) if @footer_rows);
    @rows.grep(*.so).cache;
}

sub _build_header (@widths, **@rows, *%o) is export {
    my @processed;

    # Top border
    @processed.append( %o<headers><top_left_corner_marker>
                    ~ %o<headers><top_border>
                    ~ @widths.map({ %o<headers><top_border> x $_ }).join(%o<headers><top_border>
                        ~ %o<headers><top_corner_marker>
                        ~ %o<headers><top_border>
                        ) 
                    ~ %o<headers><top_border>
                    ~ %o<headers><top_right_corner_marker>
                );

    return @processed unless @rows;

    # Column rows
    @processed.append( _row2str(@widths, $_, :type<headers>, |%o) ) for @rows;

    # Bottom border
    @processed.append( %o<headers><bottom_left_corner_marker>
                    ~ %o<headers><bottom_border>
                    ~ @widths.map({ %o<headers><bottom_border> x $_ }).join(%o<headers><bottom_border>
                        ~ %o<headers><bottom_corner_marker>
                        ~ %o<headers><bottom_border>
                        ) 
                    ~ %o<headers><bottom_border>
                    ~ %o<headers><bottom_right_corner_marker>
                );

    @processed;
}

sub _build_body (@widths, **@rows, *%o) is export {
    my Str @processed;

    # Process rows
    @processed.append( _row2str(@widths, $_, :type<rows>, |%o) ) for @rows;

    # Bottom border
    @processed.append( %o<rows><bottom_left_corner_marker>
                    ~ %o<rows><bottom_border>
                    ~ @widths.map({ %o<rows><bottom_border> x $_ }).join(%o<rows><bottom_border>
                        ~ %o<rows><bottom_corner_marker>
                        ~ %o<rows><bottom_border>
                        ) 
                    ~ %o<rows><bottom_border>
                    ~ %o<rows><bottom_right_corner_marker>
                );

    @processed;
}

sub _build_footer (@widths, **@rows, *%o) is export {
    return unless @rows.elems;
    my Str @processed;

    # Column rows
    @processed.append( _row2str(@widths, $_, :type<footers>, |%o) ) for @rows;

    # Bottom border
    @processed.append( %o<footers><bottom_left_corner_marker>
                    ~ %o<footers><bottom_border>
                    ~ @widths.map({ %o<footers><bottom_border> x $_ }).join(%o<footers><bottom_border>
                        ~ %o<footers><bottom_corner_marker>
                        ~ %o<footers><bottom_border>
                        ) 
                    ~ %o<footers><bottom_border> 
                    ~ %o<footers><bottom_right_corner_marker> 
                );

    @processed;
}

# returns formatted row
sub _row2str (@widths, @cells, :$type where any(%defaults.keys), *%o) {
    my $csep            = %o{$type}<column_separator>;
    my $format          = "$csep " ~ join( " $csep ", @widths.map({"%-{$_}s"}) ) ~ " $csep";
    my @sanitized_cells = @cells.map: { $_ // '' };
    my $height          = @sanitized_cells.map(*.lines.elems).max;

    my @rows;
    for 0..($height - 1) -> $current-height {
        my $line = sprintf $format, @sanitized_cells.map(*.lines[$current-height]).map: { $_ // '' };
        push @rows, $line;
    }
    @rows.join: "\n";
}

# Iterate over ([1,2,3],[2,3,4,5],[33,4,3,2]) to find the longest string in each column
sub _get_column_widths (**@rows, *%o) is export {
    my @r = @rows.grep: &so;
    (0..@r[0].end).map: -> $col {
        # work around stuff like Int.max or "".lines.max returning -4 chars ala ''.lines.chars
        @r[*;$col].map({ .defined && .chars ?? .lines.max(*.chars).chars !! 0 }).max;
    }
}

sub _build_options (%o) {
    my Hash() %options = %defaults;

    %options.append: %o;

    # If specific corner markers are not provided, use the (default) corner marker
    for %options.keys -> $type {
        my @corners = |<bottom bottom_left bottom_right>, |do <top top_left top_right> if $type eq 'headers';

        for @corners {
            %options{$type}{"{$_}_corner_marker"} //= %o{$type}<corner_marker> // %defaults{$type}<corner_marker>
        }
    }

    %options
}

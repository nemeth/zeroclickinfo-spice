package DDG::Spice::Drinks;
# ABSTRACT: Drink mixing instructions

use strict;
use DDG::Spice;
use Text::Trim;

spice is_cached => 1;

name "Drinks";
description "Bartending info";
primary_example_queries "how to make a mojito";
secondary_example_queries "what ingredients are being used within gin fizz", "long island cocktail";

code_url "https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Spice/Drinks.pm";
attribution github  => ["https://github.com/mutilator", "mutilator"],
            github  => ["https://github.com/ozdemirburak", "Burak Özdemir"],
            twitter => ["https://twitter.com/ozdemirbur", "Burak Özdemir"],
            web     => ["http://burakozdemir.co.uk", "Burak Özdemir"];

spice to => 'http://www.thecocktaildb.com/api/json/v1/1/search.php?s=$1';
spice wrap_jsonp_callback => 1;

triggers any => ('cocktail', 'drink', 'ingredient', 'ingredients', 'make', 'making', 'mix', 'mixing', 'recipe');

my %drinks = map { trim($_) => 0 } share('drinks.txt')->slurp;
my @stop_words = ("a", "an", "are", "being", "for", "how", "in", "is", "needed", "of", "that", "to", "used", "what", "within");
my ($rx) = map qr/(?:$_)/, join "|", map qr/\b\Q$_\E\b/, @stop_words;

# Handle statement
handle remainder_lc => sub {
    $_ =~ s/$rx//g;
    my $drink = trim($_);
    if (exists($drinks{$drink})) {
        return $drink if $drink ne "";
    }
    return;
};

1;

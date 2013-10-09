#!/usr/bin/perl

#use strict;
use warnings;

use List::Util qw(min reduce);

sub min_edit_distance {
    my ($target, $source) = @_;
    my @ar1 = split //, $target;
    my @ar2 = split //, $source;

    my @distances;
    $distances[$_][0] = $_ foreach (0 .. @ar1);
    $distances[0][$_] = $_ foreach (0 .. @ar2);

    my @direction = ("A", "B", "C");
    my $distance;
    my $L;
    my $D;
    my $C;

    foreach my $i (1 .. @ar1){
        foreach my $j (1 .. @ar2){
            my $cost = $ar1[$i - 1] eq $ar2[$j - 1] ? 0 : 2;

            $L = $distances[$i - 1][$j] + 1;
            $D = $distances[$i][$j - 1] + 1;
            $C = $distances[$i - 1][$j - 1] + $cost;
            $distance = min($L, $D, $C);

            if ($distance == $L) {
                push @direction, "L";
            } elsif ($distance == $D) {
                push @direction, "D";
            } else {
                push @direction, "C";
            }

            $distances[$i][$j] = $distance;
        }
    }

    @bleh = ($distances[@ar1][@ar2], @direction);

    return @bleh;
}

my %dictionary;

open(my $fh, "<", "wordlist.txt")
    or die "Unable to open file, $!";

while (my $word = <$fh>) {
    chomp($word);
    $dictionary{$word} = 0;
}

close($fh)
    or warn "Unable to close file, $!";


open($fh, "<", "misspellings.txt")
    or die "Unable to open file, $!";

while (my $word = <$fh>) {
    chomp($word);
    if (not exists $dictionary{$word}) {
        my @top_words = ("0", "1", "2");
        my %top_word_distances = (
            "0" => 9999,
            "1" => 9999,
            "2" => 9999
        );
        my %routes = (
            "0" => qw/0/,
            "1" => qw/1/,
            "2" => qw/2/
        );


        foreach my $key (keys %dictionary) {
            if (abs(length($key) - length($word)) <= $top_word_distances{$top_words[2]}) {
                @route = min_edit_distance($key, $word);
                #print @route;
                if ($route[0] < $top_word_distances{$top_words[2]}) {
                    delete $routes{$top_words[2]};
                    delete $top_word_distances{$top_words[2]};
                    $routes{$key} = @route[1, -1];
                    $top_word_distances{$key} = $route[0];
                    @top_words = (sort { $top_word_distances{$a} <=> $top_word_distances{$b} } keys %top_word_distances);
                }
            }
        }

        print "Misspelled: $word; Suggested: ";
        print %top_word_distances;
        print ", ";
        print $routes{"fated"};
        print"\n";
    }
}

close($fh)
    or warn "Unable to close file, $!";

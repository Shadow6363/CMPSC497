#!/usr/bin/perl

#use strict;
use warnings;

use List::Util qw(min reduce);

sub min_edit_distance {
    my ($target, $source) = @_;
    my @ar1 = split //, $target;
    my @ar2 = split //, $source;

    my @distances;
    $distances[$_][0][0] = $_ foreach (0 .. @ar1);
    $distances[0][$_][0] = $_ foreach (0 .. @ar2);
    $distances[$_][0][1] = "L" foreach (0 .. @ar1);
    $distances[0][$_][1] = "D" foreach (0 .. @ar2);
    $distances[0][0][1] = "C";

    my $direction = "";
    my $distance;
    my $L;
    my $D;
    my $C;

    foreach my $i (1 .. @ar1){
        foreach my $j (1 .. @ar2){
            my $cost = $ar1[$i - 1] eq $ar2[$j - 1] ? 0 : 2;

            $L = $distances[$i - 1][$j][0] + 1;
            $D = $distances[$i][$j - 1][0] + 1;
            $C = $distances[$i - 1][$j - 1][0] + $cost;
            $distance = min($L, $D, $C);

            if ($distance == $L) {
                $direction = "L";
            } elsif ($distance == $D) {
                $direction = "D";
            } else {
                $direction = "C";
            }

            $distances[$i][$j][0] = $distance;
            $distances[$i][$j][1] = $direction;
        }
    }


    $i = @ar1;
    $j = @ar2;
    $direction = "";
    while ($i > 0 and $j > 0) {
        if($distances[$i][$j][1] eq "D") {
            $direction = $direction . "D";
            $j = $j - 1;
        } elsif($distances[$i][$j][1] eq "L") {
            $direction = $direction . "L";
            $i = $i - 1;
        } else {
            $direction = $direction . "C";
            $i = $i - 1;
            $j = $j - 1;
        }
    }

    return ($distances[@ar1][@ar2][0], scalar reverse $direction);
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
            "0" => "",
            "1" => "",
            "2" => ""
        );


        foreach my $key (keys %dictionary) {
            if (abs(length($key) - length($word)) <= $top_word_distances{$top_words[2]}) {
                @route = min_edit_distance($key, $word);
                if ($route[0] < $top_word_distances{$top_words[2]}) {
                    delete $routes{$top_words[2]};
                    delete $top_word_distances{$top_words[2]};
                    $routes{$key} = $route[1];
                    $top_word_distances{$key} = $route[0];
                    @top_words = (sort { $top_word_distances{$a} <=> $top_word_distances{$b} } keys %top_word_distances);
                }
            }
        }

        print "Misspelled: $word; Suggested: ";
        print %top_word_distances;
        print ", ";
        print %routes;
        print"\n";
    }
}

close($fh)
    or warn "Unable to close file, $!";

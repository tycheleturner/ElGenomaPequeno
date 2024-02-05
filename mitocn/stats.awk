#!/bin/awk -f
# based on:
#   https://gist.github.com/mikewallace1979/3973059
 
BEGIN { count = 0; sum = 0 }

# skip lines that arent numbers
$1 !~ /^-?[0-9]*\.?[0-9]+$/ {
    #print "skipping: \"" $1 "\"";
    next
}

count == 0 || $1 < min { min = $1 }
count == 0 || $1 > max { max = $1 }

{ count++; sum += $1 }

END {
    # From http://www.commandlinefu.com/commands/view/1661/display-the-standard-deviation-of-a-column-of-numbers-with-awk
    if (count > 0) {
        mean = sum/count
    }
 
    print "sum: " sum
    print "count: " count
    print "min: " min
    print "max: " max
    print "mean: " mean
}



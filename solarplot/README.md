This directory is very early in development.

1. Get heteroplasmy counts
```
cat ../variants/*.pysamstats.heteroplasmy.txt | cut -f2 | sort | grep -v 'POS' | uniq -c | column -t | awk '{print $2"\t"$1}' > heteroplasmy.counts.txt
```

2. Add in the reference allele to the count file
```
Rscript combine_with_reference.R -v heteroplasmy.counts.txt -p test -o heteroplasmy.counts.for.plotter.txt
```

3. Plot the variants
```
Rscript solarplot.R -i heteroplasmy.counts.for.plotter.txt -o heteroplasmy.counts.pdf
```


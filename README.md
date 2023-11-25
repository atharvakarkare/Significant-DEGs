# Significant-DEGs and Count
The R-Script provides an easy way to filter the top table and get DEGs.

###Getting started###

Set the working directory, and give the path to the folder where output files will be stored.
install and load required packages from CRAN or BIOCONDUCTOR.
Execute the script

###Output###
The output file will be of four conditions with names:

1. gp(greater than 0.5) = p<=0.05,LogFC >0.5

2. lp(less than -0.5) = p<=0.05,LogFC <-0.5

3. go(greater than 1) = p<=0.05,LogFC >1

4. lo(less than -1) = p<=0.05,LogFC < -1

5. os(only signifigant) = p<=0.05




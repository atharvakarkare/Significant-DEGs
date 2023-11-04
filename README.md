# Significant-DEGs
The R-Script provides an easy way to filter the top table and get DEGs.

##Getting started##

Set the working directory, give path to folder.
install and load required packages from CRAN or BIOCONDUCTOR.
Execute the script

##Outputs##
The output file will be of four conditions:

1. gp(greater than 0.5) = p<=0.05,LogFC >0.5

2. lp(less than -0.5) = p<=0.05,LogFC <-0.5

3. go(greater than 1) = p<=0.05,LogFC >1

4. lo(less than -1) = p<=0.05,LogFC < -1

5. os(only signifigant) = p<=0.05




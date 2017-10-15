# metaDigitise 
[![Build Status](https://travis-ci.org/daniel1noble/metaDigitise.svg?branch=master)](https://travis-ci.org/daniel1noble/metaDigitise.svg?branch=master) 

Digitising functions in R for extracting data and summary statistics from figures in primary research papers

To install `metaDigitise` enter the following code in R:

```
install.packages("devtools")
devtools::install_github("daniel1noble/metaDigitise")
library(metaDigitise)
```

```
extract_points(" /Users/danielnoble/Dropbox/1_Research/1_Manuscripts/1_In_Preparation/packages/metaDigitise/example_figs/mean_se/1269_Ligon_2009_Fig.3.png", "mean_se")

extract_points("~/Dropbox/0_postdoc/8_PR repeat/shared/extracted graphs/29_fig1a.png", "boxplot")
 
extract_points("~/Dropbox/0_postdoc/8_PR repeat/shared/extracted graphs/33_fig2.png", "scatterplot")
```
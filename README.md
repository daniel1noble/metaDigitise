# metaDigitise 
[![Build Status](https://travis-ci.org/daniel1noble/metaDigitise.svg?branch=master)](https://travis-ci.org/daniel1noble/metaDigitise.svg?branch=master) 

Digitising functions in R for extracting data and summary statistics from figures in primary research papers

To install `metaDigitise` enter the following code in R:

```
install_github("daniel1noble/metaDigitise")
library(metaDigitise)
```

```
extract_points("~/Dropbox/0_postdoc/8_PR repeat/shared/extracted graphs/5_fig2a.png", "mean_se")

extract_points("~/Dropbox/0_postdoc/8_PR repeat/shared/extracted graphs/29_fig1a.png", "boxplot")
 
extract_points("~/Dropbox/0_postdoc/8_PR repeat/shared/extracted graphs/33_fig2.png", "scatterplot")
```
# metaDigitise 
[![Build Status](https://travis-ci.org/daniel1noble/metaDigitise.svg?branch=master)](https://travis-ci.org/daniel1noble/metaDigitise.svg?branch=master) 

# Introduction
`metaDigitise` is an R package that provides functions for extracting data and summary statistics from figures in primary research papers. Often third party applications are used to do this (e.g., graphClick or dataThief), but often the output from these are handled separately from the analysis package, making this process more laborious than it needs to me. `metaDigitise` allows users to extract information from a figure or set of figures all within the R environment making data extraction, analysis and export more streamlined. It also provides users with options to conduct the necessary calculations from raw data immediately after extraction and will condense multiple figures into data frames or lists (depending on the type of figure) and these objects can easily be exported from R. 

# Installation
To install `metaDigitise` enter the following code in R:

```
install.packages("devtools")
devtools::install_github("daniel1noble/metaDigitise")
library(metaDigitise)
```

Installation will make the primary functions for data extraction `extract_points` and `bulk_digitise` accessible to users along with their help files.

# Setting up directory structures
The package is quite flexible and is currently being made even more flexible. Users can extract single figures (if this is all they have) using the `extract_points` function with a path name to the specific file needing extraction. However, often many figures need extracting from a single paper or set of papers. Users can get creative in how they set up the directories of figures (.png images) to facilitate extraction. For example, one might have 3–4 figures from a single paper that needs extracting and the user may want to focus on a single paper at a time as the need to extract comes up. This could be done by simply setting up a file structure as follows:

	* Main project directory
		+ Paper1_P1
			+ P1_Figure1.png
			+ P1_Figure2.png
			+ P1_Figure3.png
		+ Paper2_P2
			+ P2_Figure1.png
			+ P2_Figure2.png
			+ P2_Figure3.png

An alternative folder structure could simply be to have a set of different papers with informative and relevant naming scheme to make it easy to identify the data coming from each figure. For example:

	* Main project directory
		+ FiguresToExtract
			+ P1_Figure1_trait1.png
			+ P1_Figure2_trait2.png
			+ P1_Figure3_trait3.png
			+ P2_Figure1_trait1.png
			+ P2_Figure2_trait2.png
			+ P2_Figure3_trait3.png

How users set up there directory is really up to them and there are a number of arguments that allow users to specify whether figures are of `diff` or `same` type so that the correct summary statistics are calculated. 

# Example of how it works





########################################################################

```
extract_points("./example_figs/mean_se/1269_Ligon_2009_Fig.3.png", "mean_se")

extract_points("~/Dropbox/0_postdoc/8_PR repeat/shared/extracted graphs/29_fig1a.png", "boxplot")
 
extract_points("~/Dropbox/0_postdoc/8_PR repeat/shared/extracted graphs/33_fig2.png", "scatterplot")
```
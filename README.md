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
The package is quite flexible and is currently being made even more flexible. Users can extract single figures (if this is all they have) using the `extract_points` function with a path name to the specific file needing extraction. However, often many figures need extracting from a single paper or set of papers and, so, `bulk_digitise` helps expedite this situation preventing users from having to constantly specify the directories were files are stored. `bulk_digitise` essentially will bring up each figure within a folder automatically and allow the user to click and enter the relevant information about a figure as you go. This information is then all stored in a data frame or list at the end of the process, saving quite a bit of time.

Users can get creative in how they set up the directories of figures (.png images) to facilitate extraction. For example, one might have 3–4 figures from a single paper that needs extracting and the user may want to focus on a single paper at a time as the need to extract comes up. This could be done by simply setting up a file structure as follows and then using `bulk_digitise` for each papers folder:

	* Main project directory
		+ Paper1_P1
			+ P1_Figure1.png
			+ P1_Figure2.png
			+ P1_Figure3.png
		+ Paper2_P2
			+ P2_Figure1.png
			+ P2_Figure2.png
			+ P2_Figure3.png

An alternative directory structure could simply be to have a set of different figures with informative and relevant naming scheme to make it easy to identify where the data coming from each paper and figure come from, but cutting out the need to change directories constantly. For example:

	* Main project directory
		+ FiguresToExtract
			+ P1_Figure1_trait1.png
			+ P1_Figure2_trait2.png
			+ P1_Figure3_trait3.png
			+ P2_Figure1_trait1.png
			+ P2_Figure2_trait2.png
			+ P2_Figure3_trait3.png

How users set up there directory is really up to them and there are a number of arguments that allow users to specify whether figures are of `diff` or `same` type so that the correct summary statistics, raw data or whatever are calculated. 

# Example of how it works
We'll first demonstrate how `extract_points` works when the user simply wants to extract data from a single figure. In this case, we have within our `example_figs/` folder two figures (1269_ligon_2009_Fig.3.png and 1269_ligon_2009_Fig.5.png), but we'll just use one for now (1269_ligon_2009_Fig.3.png).  Notice our naming of this file. 1269 is the paper number followed by authors, year and the figure number. This makes it easy to keep track of the figures being digitised. Here is what this figure looks like:

<img src= https://www.dropbox.com/s/j7vf4hfdl97uxl8/1269_Ligon_2009_Fig.3.png?dl=0?raw=true/>

To extract from 1269_ligon_2009_Fig.3.png all we need to do is use the following code:

```
data <- extract_points("./example_figs/mean_se/1269_Ligon_2009_Fig.3.png", "mean_se")
```

Here the output will be stored to the `data` object, which is great because we can access this after we have clicked. When executing this function the user will be prompted in the console to answer relevant questions as the image / figure is being digitised. The first of these is whether the user would like to rotate the image:

```
Rotate Image? y/n 
```

Specify y for "yes" or n for "no". If yes, this will introduce new prompts to help rotate the image in case this is needed. For now, our image (which appears on screen in the plotting window), looks fine so we'll hit `n` for now. After we do this a new message appears in the console to explain what to do next:

```
Use your mouse, and the image, 
but careful how you calibrate.
Click IN ORDER: x1, x2, y1, y2 

	
    Step 1 ----> Click on x1
  |
  |
  |
  |
  |
  |_____x1__________________


    Step 2 ----> Click on x2
  |
  |
  |
  |
  |
  |___________________x2____


    Step 3 ----> Click on y1
  |
  |
  |
  |
  y1
  |_________________________


    Step 4 ----> Click on y2
  |
  y2
  |
  |
  |
  |_________________________
  ```
Follow the instructions on screen step by step and in the order specified. As users click the figure, points will come up. Blue points are those that create the calibration and the red points are those that are the specific statistics or data points the user wants. As the user progressed a series of prompts will pop up in the R console asking for relevant information:

```
What is the value of x1 ?
1
What is the value of x2 ?
2
What is the value of y1 ?
-0.5
What is the value of y2 ?
0.5
```
The first few questions as the user what the calibration points mean. In this figure, only the y-axis is really important, so we just add 1 and 2 for the x-points.

```
Number of groups: 3
```

`metaDigitise` will then ask the user how many groups are within the figure, in this case, we have 3 treatments and so we have entered 3. Once this part is complete it asks for group identifiers, these can be the treatment names. In this case, we have three temperature treatments, and so, we enter their values, but these could be anything really:

```
Group identifier 1 :26.5
Now click on Upper SE, followed by the Mean
Continue or reclick? c/r c
Group identifier 2 :28.5
Now click on Upper SE, followed by the Mean
Continue or reclick? c/r c
Group identifier 3 :30.5
Now click on Upper SE, followed by the Mean
Continue or reclick? c/r c
```

What you will notice is that the upper SE needs to be clicked first followed by the mean. But, don't worry if you make a mistake. It will always ask you to `continue or re-click` in case you need to fix things up. In this case, we didn't make a mistake and so we continue through the prompts to finally have the relevant data printed on screen or stored to an object:

```
    id       mean        se        x
1 26.5  0.0443038 0.1265823 1.000000
2 28.5  0.2088608 0.1518987 1.508929
3 30.5 -0.4493671 0.2531646 2.017857
```


########################################################################

```
extract_points("./example_figs/mean_se/1269_Ligon_2009_Fig.3.png", "mean_se")

extract_points("~/Dropbox/0_postdoc/8_PR repeat/shared/extracted graphs/29_fig1a.png", "boxplot")
 
extract_points("~/Dropbox/0_postdoc/8_PR repeat/shared/extracted graphs/33_fig2.png", "scatterplot")
```
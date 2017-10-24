# metaDigitise 
[![Build Status](https://travis-ci.org/daniel1noble/metaDigitise.svg?branch=master)](https://travis-ci.org/daniel1noble/metaDigitise.svg?branch=master) 
[![codecov](https://codecov.io/gh/daniel1noble/metaDigitise/branch/master/graph/badge.svg)](https://codecov.io/gh/daniel1noble/metaDigitise)
[![DOI](https://zenodo.org/badge/106883244.svg)](https://zenodo.org/badge/latestdoi/106883244)

# Introduction

`metaDigitise` is an R package that provides functions for extracting raw data and summary statistics from figures in primary research papers. Often third party applications are used to do this (e.g., *graphClick* or *dataThief*), but the output from these are handled separately from the analysis package, making this process more laborious than it needs to be. `metaDigitise` allows users to extract information from a figure or set of figures all within the R environment making data extraction, analysis and export more streamlined. It also provides users with options to conduct the necessary calculations on raw data immediately after extraction so that comparable summary statistics can be obtained, and will condense multiple figures into data frames or lists (depending on the type of figure) and these objects can easily be exported from R. Conveniently, when bulk processing figures `metaDigitise` will only work on figures not already completed within a directory, so that new figures can be added at anytime without having to specify the specific file types. `metaDigitise` was built for reproducibility in mind. It has functions that allow users to redraw their digitisations on figures, correct anything and access the raw calibration data which is written automatically for each figure that is digitised into a special `caldat` folder within the directory.

# Installation

To install `metaDigitise` use the following code in R:

```
install.packages("devtools")
devtools::install_github("daniel1noble/metaDigitise")
library(metaDigitise)
```

Installation will make the primary functions for data extraction `metaDigitise` and `bulk_metaDigitise` accessible to users along with their help files. Standard base functions, such as `summary`, `print` and `plot` (used for re-plotting calibrations) will also work on `bulk_metaDigitise` objects.

# Setting up directory structures

The `metaDigitise` package is quite flexible and is currently being made even more flexible. Users can extract single figures (if this is all they have) using the `metaDigitise` function with a path name to the specific file needing extraction. However, often many figures need extracting from a single paper or set of papers and, so, `bulk_metaDigitise` helps expedite this situation preventing users from having to constantly specify the directories where files are stored. `bulk_metaDigitise` essentially will bring up each figure within a folder automatically and allow the user to click and enter the relevant information about a figure as you go. This information is then all stored in a data frame or list at the end of the process, saving quite a bit of time. Users can also quit (`control c`) at any time and the data from digitised figures will automatically be written to the `caldat/` folder for later use.

Many `metaDigitise` functions work on whole directories. Users can get creative in how they set up the directories of figures (currently .png, .jpg, .tiff, .pdf images can be used) to facilitate extraction. For example, one might have 3–4 figures from a single paper that need extracting and the user may want to focus on a single paper at a time as the need to extract comes up. This could be done by simply setting up a file structure as follows and then using `bulk_metaDigitise` for each papers folder:

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

How users set up their directory is really up to them and there are a number of arguments that allow users to specify whether figures are of `diff` or `same` type so that the correct summary statistics, raw data or whatever are calculated. 

# Example of how it works

We'll first demonstrate how the main function `metaDigitise` works when the user simply wants to extract data from a single figure. In this case, we have within our `example_figs/` folder two figures (1269_ligon_2009_Fig.3.png and 1269_ligon_2009_Fig.5.png), but we'll just use one for now (1269_ligon_2009_Fig.3.png).  Notice our naming of this file. 1269 is the paper number followed by authors, year and the figure number. This makes it easy to keep track of the figures being digitised. Here is what this figure looks like:

![1269_ligon_2009_fig 3](https://user-images.githubusercontent.com/3505482/31603164-09481386-b2ab-11e7-95a9-8d4ab2643841.png)

To extract from 1269_ligon_2009_Fig.3.png all we need to do is use the following code:

```
data <- metaDigitise("./example_figs/mean_se/1269_Ligon_2009_Fig.3.png")
```

Here, the output will be stored to the `data` object, which is great because we can access this after we have clicked. When executing this function the user will be prompted in the console to answer relevant questions as the image / figure is being digitised. The first of these is whether the user would like to rotate the image:

```
mean_error and boxplots should be vertically orientated
       _ 
       |	
  I.E. o    NOT  |-o-|
       |
       _

If they are not then chose flip to correct this.

If figures are wonky, chose rotate.

Otherwise chose continue

Flip, rotate or continue f/r/c 
```

Specify `f`for "Flip", `r` for "rotate" or `c` for "continue. For now, our image (which appears on screen in the plotting window), looks fine so we'll hit `c` for now. After we do this `metaDigistise` will ask the user to specify the plot type:

```
Please specify the plot_type as either: mean and error, box plot, scatter plot or histogram m/b/s/h:
```
Depending on the figure one has the user can specify that it is a figure containing the mean and error (`m`), a box plot (`b`), a scatter plot (`s`) or a histogram (`h`). After selecting the figure type a new set of prompts will come up that will ask the user to calibrate the x and y-axis so that the relevant statistics / data can be correctly calculated. Since we are working with a plot of the mean and standard errors, the x-axis is rather useless in terms of calibration so `metaDigitise` just asks us to calibrate the y-axis. Note here that it first asks us what the variable in the plot is. This is useful as you can keep track of the different variables across different figures.

```
What is the variable? Residuals

On the Figure, click IN ORDER: 
      y1, y2  


    Step 1 ----> Click on y1
  |
  |
  |
  |
  y1
  |_________________________


    Step 2 ----> Click on y2
  |
  y2
  |
  |
  |
  |_________________________
  

  ```
Follow the instructions on screen step-by-step, and in the order specified. The user will be asked to specify the x and y calibration points (in this case only the y). 

```
What is the value of y1 ?
-1

What is the value of y2 ?
1

Re-calibrate? (y/n) 
```
The first few questions ask the user what the calibration points are. In this figure, only the y-axis is really important, so again, we only have to enter the y-axis coordinates.

```
Number of groups: 3
Enter sample sizes? y/n
```

`metaDigitise` will then ask the user how many groups are within the figure, in this case, we have 3 treatments and so we have entered 3. We will be prompted to tell `metaDigitise` whether we know the sample sizes for these treatments. This is useful for back-calculating from standard error to standard deviation or some other form of error. If we know these we can choose `y`, indicating that we do know the sample size. Once this part is complete it asks for group identifiers, these can be the treatment names. In this case, we have three temperature treatments, and so, we enter their values, but these could be anything really:

```
Group identifier 1 : 26.5
Group sample size: 20
Click on Error Bar, followed by the Mean
Continue or reclick? c/r c
Group identifier 2 : 28.5
Group sample size: 12
Click on Error Bar, followed by the Mean
Continue or reclick? c/r c
Group identifier 3 : 30.5
Group sample size: 10
Click on Error Bar, followed by the Mean
Continue or reclick? c/r c
Type of error (se, CI95, sd, range): se
```

After specifying the group name, will be will asked what the sample size is for each treatment. Users may need to refer back to the paper for this or they could include the figure legend in if these contain relevant information. As users click the figure, points will come up. Blue points are those that create the calibration and the red points are those that are the specific statistics or data points the user wants. As the user progresses, prompts will pop up in the R console asking for relevant information before new information is digitised:

![Example of a metaDigitised figure](https://user-images.githubusercontent.com/3505482/31927831-65c8cae2-b8e1-11e7-8888-1decdc73c5ee.png)

`meta-Digitise` will conveniently print on the figure the calibration numbers along with group names and sample sizes (in brackets). It will also print the figure name, which is useful if the user needs to go back and find the paper to obtain information. This is useful for the user to be checking their input with actual values on the figure. Note that the error needs to be clicked first followed by the mean. But, don't worry if you make a mistake. It will always ask you to `continue or re-click` in case you need to fix things up. In this case, we didn't make a mistake and so we continue through the prompts to finally have the relevant data stored in the data object. We can then query the summary of this object:

```
 summary(data)
                   filename group_id  variable       mean        sd  n  r  plot_type
1 1269_Ligon_2009_Fig.3.png     26.5 Residuals  0.0376134 0.5961405 20 NA mean_error
2 1269_Ligon_2009_Fig.3.png     28.5 Residuals  0.2062570 0.5496178 12 NA mean_error
3 1269_Ligon_2009_Fig.3.png     30.5 Residuals -0.4541619 0.7691445 10 NA mean_error
```

Our summary output has all the relevant information about the means and the standard errors, which are automatically converted to standard deviations. The user will notice an `r` column indicating the correlation coefficient. This is not needed in this specific plot type, but see below for outputs of different types of figures in the `bulk_metaDigitise` function. We can also print the `metaDigitise` object to find out more details:

```
print(data)
Data extracted from:
 ./example_figs/mean_se/1269_Ligon_2009_Fig.3.png 
Figure rotated 0 degrees 
Figure identified as mean_error with 3 groups 
```

For reproducibility, all the calibration data can be exported and over layed on a graph at a later date. Given that all the data is stored in the data object, if we accidentally close the plotting window, we can replot our figure, calibrations and selected points using:

```
plot(data)
```

This will bring up the plot shown above.

# Bulk Digistising Images

Often a paper contains many figures needing extracting and having to open and re-open new files, save data etc takes up a lot of unncessary time. `bulk_metaDigitise` solves this problem by gradually working through all files within a directory, allowing users to digitise from them and then saving the output from all digitsiations in a single data frame. This function can be executed simply as:

```
data <- bulk_metaDigitise(dir = "./example_figs/", types = "same", summary = TRUE)
```

Here, the user simply specifies the directory folder where all the files are contained. The `types` arguments tells R whether the figures in the folder are different types, in which case `bulk_metaDigitise` will ask the user to specify the type of figure prior to digitising and save all these results. Alternatively, if the `type = same` then it will simply cycle through all the figures within the folder after specifying the plot type right at the beginning. An alternative directory structure to the ones specified above, is to simply put all like figures in the same folder and process these all at once or in batches. This can at times speed things up and make life easier. Another trick to digitising in bulk is to include the figure legends in the image, allowing you to quickly get information that is relevant should you need it.

In this specific example, we use a directory where there are two different types of figures (different types from above to demonstrate the flexibility of `metaDigitise`), a scatter plot and a histogram:

![Scatterplot](https://user-images.githubusercontent.com/3505482/31928575-5a9b8580-b8e4-11e7-876d-19cc7b7f9a15.png)
![Histogram of a variable](https://user-images.githubusercontent.com/3505482/31928517-305f9acc-b8e4-11e7-97a0-6b8e5d05522b.png)

These are just simulated data for the time being to demonstrate how `bulk_metaDigitise` works. Both thes figures are held in the `"./example_figs/example_figs_2/"` directory. Currently the directory looks like this:

```
  *example_figs_2
      +1_histo_x.png
      +1_scatterplot.png
```

We can bulk process these figures, maybe they are from the same paper, for example. This can be done as follows:

```
data_eg2 <- bulk_metaDigitise(dir="./example_figs/example_figs_2/", types = "diff", summary = TRUE)
```

Here, we simply give the entire directory where the figures are located. The `types = "diff"` argument states that the figures within the directory are different types. The `summary = TRUE` argument tells `bulk_metaDigitise` that we want only simple summaries saved. This might not what the user wants in all cases. For example, the user may want the raw data back in the scatterplot. If this is the case then simply change `summary = FALSE`. The returned object will be different depending on whether all objects are the `same` or `diff` type. If the `same` then everything will be concatenated into a data frame, but if different, a list of the relevant processed data will be returned for each figure. We are asked the exact same prompts as before, but because these are different figures we have slightly different needs, and so, some new ones show up that direct the user through the process. For the first figure, we have our histogram:

```Please specify the plot_type as either: mean and error, box plot, scatter plot or histogram m/b/s/h: h

What is the variable? Hair length (mm)

```

Here we specify the plot type as `h` for histogram and type in what the variable is, in this case Hair length (mm). We then get our normal calibration prompts, but this time need to calibrate both x and y:

```
On the Figure, click IN ORDER: 
      y1, y2 , x1, x2  

    Step 1 ----> Click on y1
  |
  |
  |
  |
  y1
  |_________________________

  ....
 
    Step 3 ----> Click on x1
  |
  |
  |
  |
  |
  |_____x1__________________
  ....
```

We then plug in the calibration point values and check that everything is ok:

```
What is the value of y1 ?
0
What is the value of y2 ?
15
What is the value of x1 ?
-2
What is the value of x2 ?
3
Re-calibrate? (y/n) n
```

Digitising information from histograms is a little bit more involved than other plots because we need to characterize the entire distribution directly. This is done by clicking the left and right corners of each bar. We can only do one bar at a time before being prompted to re click, continue (finishing the plot) or we can add to put points on all the bars. We need to characterize everything so we continue adding on points:

```
Click on left then right upper corners of bar
Add, reclick or continue? a/r/c a
Click on left then right upper corners of bar
Add, reclick or continue? a/r/c a
Click on left then right upper corners of bar
Add, reclick or continue? a/r/c a
Click on left then right upper corners of bar
Add, reclick or continue? a/r/c a
Click on left then right upper corners of bar
Add, reclick or continue? a/r/c c
```

<img width="792" alt="histogram_digitising" src="https://user-images.githubusercontent.com/3505482/31929607-7030af52-b8e8-11e7-9224-c9ce5ba24e28.png">

Once done the histogram, we are immediately prompted to the next figure, in this case the scatter plot. This is handy because we often would need to re-specify the directory and file when digitizing, which wastes a lot of time. Importantly, the user can quit at any point (maybe you need a coffee, or need to run for a beer with colleagues) using `control c`. We'll continue now to digitsing the scatter plot:

```Please specify the plot_type as either: mean and error, box plot, scatter plot or histogram m/b/s/h: s

What is the x variable? x
What is the y variable? y
```

here we gives the axis labels and then follow on form this to do the calibration specifying the x and y coordinates just like above. `metaDigitise` allows multiple groups to be specified within scatter plots as well and the user will be prompted to specify the number of groups followed by the group ID:

```
Number of groups: 2
Follow instructions below, to exit point adding or removing:

 - Windows: right click on the plot area and choose 'Stop'!

 - X11: hit any mouse button other than the left one.

 - quartz/OS X: hit ESC

Group identifier 1 :Open circles 
```

We can specify up to 9 groups where each group will have unique symbols and colours to make it easy for the user to keep track of where they are and what all symbols mean. As the user progresses, the prompts will then tell the user what to do next:

```
Click on points you want to add
 
 If you want to remove a point, or are finished with a group,
 exit (see above), then follow prompts, 

Add, remove or continue? a/r/c c
``` 

This will continue through each group and the final digitized plot will look something like this:

<img width="545" alt="scatterplot_digitised" src="https://user-images.githubusercontent.com/3505482/31929851-27864680-b8e9-11e7-89dc-3220907db7aa.png">

Information is again printed on the figure for each group to allow the user to check. Sample sizes don't need to be specif iced in either of the figures because we can get this information from the figure itself. Once we are finished we can have a look at the object:

```
print(data_eg2)
         filename     group_id         variable       mean        sd  n         r   plot_type
1     1_histo_x.png         <NA> Hair length (mm) 0.03098954 1.0445928 30        NA   histogram
2 1_scatterplot.png Open circles                x 0.04086579 0.8039671 15 0.4343518 scatterplot
3 1_scatterplot.png Open circles                y 6.51566703 1.0625279 15 0.4343518 scatterplot
4 1_scatterplot.png Gray circles                x 0.14537999 0.7568024 15 0.6695450 scatterplot
5 1_scatterplot.png Gray circles                y 4.19254287 1.5910878 15 0.6695450 scatterplot
```

This has already been conveniently summarized for us despite having different figure types. Given that we have a scatter plot, we can derive the correlation between `x` and `y`, and we see this printed in the summary. In any case the processed information (should the user want the raw data) can be grabbed at any point be re-loading the calibration files which have been automatically written to the `caldat/` folder inside the directory:

```
  *example_figs_2/
      caldat/
        +1_histo_x
        +1_scatterplot
      +1_histo_x.png
      +1_scatterplot.png
```

# Conclusions

We are still actively developing `metaDigitise` particularly post-processing functions for reproducibility. We would be more than happy to hear what you think of it, possible improvements or bugs that are found. Please lodge an issue and we can try and deal with these as soon as possible. Also feel free to email the package maintainers. 

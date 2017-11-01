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

Installation will make the primary function for data extraction, `metaDigitise`, accessible to users along with its help file. 

# Setting up directory structures

The `metaDigitise` package is quite flexible and is currently being made even more flexible. Users can extract single figures (if this is all they have) using the `metaDigitise` function with a path name to the directory with the file. However, often many figures need extracting from a single paper or set of papers. `metaDigitise` will also handle situation this seamlessly by simply cycling through all figures within the directory. This is useful because it expedites digitising figures as it prevents users from having to constantly specify the directories where files are stored. `metaDigitise` essentially will bring up each figure within a folder automatically and allow the user to click and enter the relevant information about a figure as you go. This information is then all stored in a data frame or list at the end of the process, saving quite a bit of time. Users can stop mid-way through a folder by simplying exiting after the last plot they have digitised.  The data from completed figures will automatically be written to the `caldat/` folder for later use and editing should the user need to do this.

`metaDigitise` can work on a directory with figures (currently .png, .jpg, .tiff, .pdf images can be used) from many different papers and if different type. However, users can get creative in how they set up the directories of figures  to facilitate extraction. For example, one might have 3–4 figures from a single paper that need extracting and the user may want to focus on a single paper at a time as the need to extract comes up and information about a paper is fresh in the users head. This could be done by simply setting up a file structure as follows and then using `bulk_metaDigitise` for each papers folder:

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

How users set up their directory is really up to them, but the latter one is probably easiest in combination with a clear and unambiguous naming scheme for each figure. Even if only figures from a single paper are digitised one paper at a time, an overall figure directory will work perfectly because `metaDigitise` will only cycle through incomplete figures, so figures can be added at anytime.

# Example of how it works

We'll first demonstrate how `metaDigitise` works when the user simply wants to extract data from a single figure. Here, we'll use the `iris` dataset and some plots from this dataset to demonstrate. In this case, we have within our `example_figs/` folder in our meta-analysis project directory a scatter plot of sepal length and width for two species (setosa and versicolor). We've labeled this file 001_Anderson_1935_Fig1.png. Notice our naming of this file. 001 is the paper number followed by author, year (in this case the data was collected by E. Anderson in 1935) and the figure number. This makes it easy to keep track of the figures being digitised. Here is what this figure looks like:

![001_anderson_1935_fig1](https://user-images.githubusercontent.com/3505482/32259397-651ea5a6-bf14-11e7-8073-a18aa7bd3094.png)

To extract from 001_Anderson_1935_Fig1.png we'll first set the working directory to the folder containing images. While this step isn't completely necessary, it currently is if you would like someone to be able to reproduce the digitisations, which of course we advocate (see below). Our code will therefore be as follows:

```
setwd("~/example_figs/")
data <- metaDigitise(dir = ".")
```

Here, the output will be stored to the `data` object, which is great because we can access this after we have digitised. The `"."` just tells `metaDigitise` that we would like to execute the function from the current image folder. We just need to give the directory where the figure is located and we are off to the races. When executing this function the user will be prompted in the console to answer relevant questions as the image / figure is being digitised. The first is is to tell `metaDigitise` what you would like to do:

```
Do you want to...

1: Process new images
2: Import existing data
3: Edit existing data

Selection: 
```

All the user needs to enter is the number related to the specific process. In this case, we have not digitised any data yet, and so, if we choose option `2` or `3` it will tell us that there are no digitised functions to work with. So, our only option is `1`, which will allow us to digitise the specific file within this directory.

The next thing we are asked is whether we have different types of plot(s) in the folder. This question is most relevant for a directory with lots of figures, but we have the same plot type here (scatterplot) and so we specify "same". 

```
Are all plot types the same? (diff/same)
```

We are next asked whether we want to flip  or rotate the figure image. This can happen when box plots and mean and error plots are not orientated correctly. In some cases, older papers can give slightly off angled images which can be corrected by rotating. So, in this prompt the user has three options: `f` for "Flip", `r` for "rotate" or `c` for "continue. For now, our image (which appears on screen in the plotting window), looks fine so we'll hit `c` for now. 

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

Flip, rotate or continue f/r/c c
```

After we do this `metaDigistise` will ask the user to specify the plot type. Depending on the figure one has the user can specify that it is a figure containing the mean and error (`m`), a box plot (`b`), a scatter plot (`s`) or a histogram (`h`). If the user has specified `diff` instead of `same` to whether the plot types are the same or different this question will pop up for each plot, but will only be asked once if plots are all the same.

```
Please specify the plot_type as either: mean and error, box plot, scatter plot or histogram m/b/s/h:
```

After selecting the figure type a new set of prompts will come up that will ask the user first what the y and x-axis variables are. This is useful as you can keep track of the different variables across different figures. Here the user can just add these in. Once complete, we'll get prompted to calibrate the x and y-axis so that the relevant statistics / data can be correctly calculated. If we were  working with a plot of the mean and standard errors, the x-axis is rather useless in terms of calibration so `metaDigitise` just asks us to calibrate the y-axis. 

```
What is the y variable? Sepal Length (mm)

What is the x variable? Sepal Width (mm)

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

Follow the instructions on screen step-by-step, and in the order specified. The user will then be asked to specify the x and y calibration points and whether or not the calibration has been set up correctly. If `n` is chosen because something needs to be fixed then the user can re-calibrate.. 

```
What is the value of y1 ?
4.5
What is the value of y2 ?
7
What is the value of x1 ?
2
What is the value of x2 ?
4

Re-calibrate? (y/n) 
```

The first few questions ask the user what the calibration points are. In this figure, only the y-axis is really important, so again, we only have to enter the y-axis coordinates. Often, plots might contain multiple groups that the meta-analyst wants to extract from. `metaDigitise` handles this nicely by prompting the meta-analyst to enter the group first, followed by the digitisation of this groups data. After digitising the first group and exited (i.e., hit `esc` from plot window) `mteaDigitise` will ask the meta-analyst whether the would like to add another group. They can add another, or simply continue. The number of groups are not really limited and users can just keep adding in groups (although it gets complicated with too many).

```
Follow instructions below, to exit point adding or removing:

 - Windows: right click on the plot area and choose 'Stop'!

 - X11: hit any mouse button other than the left one.

 - quartz/OS X: hit ESC

Group identifier: setosa

Click on points you want to add.
If you want to remove a point, or are finished with a
group, exit (see above), then follow prompts

Add points, delete points or continue? a/d/c c

```

Once we are done digitising all the groups our plot will look something like this:

![rplot](https://user-images.githubusercontent.com/3505482/32259894-071cdcc6-bf18-11e7-8e19-c8d449f9fe01.png)

`meta-Digitise` will conveniently print on the figure the calibration numbers along with group names and sample sizes. It will also print the figure name, which is useful if the user needs to go back and find the paper to obtain information. Printing this information on the figure is useful so that input can be checked with actual values on the figure, and any mistakes corrected.  Don't worry if you notice a mistake. Prior to exiting the figure you will be prompted with this:

```
Add group, Edit group, Delete group, or Finish plot? a/e/d/f f
```

Choosing `e` allows the users to go back and edit a group already digitised entirely, but also, `d` allows them to completely delete one, if you wish to start over. In our case, all has gone well and do we choose `f` to finish plotting. This will exit metaDigitise (since we only have a single figure) and save the digitised output that can be conveniently queried by printing the object:

```
 data
                   filename   group_id         variable       mean      sd  n         r  plot_type
1 iris_scatter_multigrp.png     setosa  Sepal Width (mm) 3.420332 0.4034259 39 0.7524909 scatterplot
2 iris_scatter_multigrp.png     setosa Sepal Length (mm) 4.998267 0.3831294 39 0.7524909 scatterplot
3 iris_scatter_multigrp.png versicolor  Sepal Width (mm) 2.766857 0.3234723 44 0.5157938 scatterplot
4 iris_scatter_multigrp.png versicolor Sepal Length (mm) 5.936769 0.5292535 44 0.5157938 scatterplot
```

Our summary output has all the relevant information about the means and standard deviations for each of the variables. The user will notice an `r` column indicating the correlation coefficient between Sepal width and length for each species (provided because this is a scatterplot). These match reasonably well with the actual means of Sepal length and width for each of the species:

```
     Species meanSL meanSW
1     setosa  5.006  3.428
2 versicolor  5.936  2.770
```

One thing anyone with a familiarity with the iris dataset will notice is that the sample sizes for each of these species (which are n = 50 each) are quite a bit lower. This is an examplar of some of the challenged extracting data from figures, often data points will overlap with each other making it impossible (without having the real data) to know whether this is a problem. However, a meta-analyst will probably realise that the same sizes here conflict with what is reported in the paper. Hence, we also provide the user with an option to input the sample sizes directly, even for scatterplots and histograms where, strictly speaking, this shouldn't be necessary. Nonetheless, it is important to recognise the impact that overlapping points can have (particularly its effects on SD and SE). In our case, our mean point estimates are nearly bang on, but the SD's are slightly over-estimated:

```
     Species    meanSL    meanSW
1     setosa 0.3524897 0.3790644
2 versicolor 0.5161711 0.3137983
```

While this is a problem for any program digitising from figures, it probably the best that can be done. However, for reproducibility, all the calibration and raw data is exported to a special folder `caldat/`, which can be brought back in and edited at any time should new information come to light.

# Processing batches of figures of different types

Often a paper, and often a single meta-analytic project, contains many figures needing extracting and having to open and re-open new files, save data, analyse or summarize data, make conversions etc takes up a lot of unnecessary time. `metaDigitise` solves this problem by gradually working through all files within a directory, allowing users to digitise from them and then saving the output from all digitsiations in a single data frame and providing summary statistics by default. `metaDigitise` automatically does this for the meta-analyst without having to use a different function or special set of arguments. All we have to do is, again, provide the directory where all the figures are located:

```
data <- metaDigitise(dir = "./example_figs/")
```

Here, the folder now contains our original scatter plot, but also a histogram of Sepal.WidthAn alternative directory structure to the ones specified above, is to simply put all like figures in the same folder and process these all at once or in batches. This can at times speed things up and make life easier. Another trick to digitising in bulk is to include the figure legends in the image, allowing you to quickly get information that is relevant should you need it.

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



#########
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
Note that the error needs to be clicked first followed by the mean. But, don't worry if you make a mistake. It will always ask you to `continue or re-click` in case you need to fix things up.

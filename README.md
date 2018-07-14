# metaDigitise 
[![Build Status](https://travis-ci.org/daniel1noble/metaDigitise.svg?branch=master)](https://travis-ci.org/daniel1noble/metaDigitise.svg?branch=master) 
[![codecov](https://codecov.io/gh/daniel1noble/metaDigitise/branch/master/graph/badge.svg)](https://codecov.io/gh/daniel1noble/metaDigitise)

# Table of contents
1. [Introduction](#Introduction)
2. [Citing metaDigitise](#citing)
3. [Installation](#Installation) 
4. [Setting up directory structures](#P3)
5. [Example of how it works](#P4)
6. [Processing batches of figures of different types](#P5)
7. [Re-importing previously digitised data and accessing raw data](#P6) 
8. [Editing and plotting digitised figures](#P7)
9. [Conclusion](#Conclusion)

# Introduction <a name="Introduction"></a>

`metaDigitise` is an R package that provides functions for extracting raw data and summary statistics from figures in primary research papers. Often third party applications are used to do this (e.g., `graphClick` or `dataThief`), but the output from these are handled separately from the analysis package, making this process more laborious than it needs to be given that resulting output still requires substantial downstream processing to acquire the relevant statistics of interest. `metaDigitise` allows users to extract information from a figure or set of figures all within the R environment making data extraction, analysis and export more streamlined. It also provides users with options to conduct the necessary calculations on raw data immediately after extraction so that comparable summary statistics can be obtained quickly. Summaries will condense multiple figures into data frames or lists (depending on the type of figure) and these objects can easily be exported from R, or if using the raw data, analysed in any way the user desires. Conveniently, when needing to process many figures at different times `metaDigitise` will only import figures not already completed within a directory. This makes it easy to add new figures at anytime. `metaDigitise` has also been built for reproducibility in mind. It has functions that allow users to redraw their digitisations on figures, correct anything and access the raw calibration data which is written automatically for each figure that is digitised into a special `caldat` folder within the directory. This makes sharing figure digitisation and reproducing the work of others simple and easy and allows meta-analysts to update existing studies more easily.

# Citing metaDigitise <a name="citing"></a>

To cite metaDigitise in publications one can use the following reference:

```
Pick, J.L., Nakagawa, S., Noble D.W.A. (2018) 
Reproducible, flexible and high-throughput data extraction from primary 
literature: The metaDigitise R package. Biorxiv, https://doi.org/10.1101/247775
```
# Installation <a name="Installation"></a>

To install `metaDigitise` use the following code in R:

```
install.packages("devtools")
devtools::install_github("daniel1noble/metaDigitise")
library(metaDigitise)
```

Installation will make the primary function for data extraction, `metaDigitise()`, accessible to users along with its help file. 

# Setting up directory structures <a name="P3"></a>

The `metaDigitise` package is quite flexible. Users can extract single figures (if this is all they have) using the `metaDigitise()` function with a path name to the directory with the file. However, often many figures need extracting from a single paper or set of papers. `metaDigitise` will also handle these situations seamlessly by simply cycling through all figures within a directory. This is useful because it expedites digitising figures as it prevents users from having to constantly specify the directories and / or paths where files are stored. `metaDigitise` essentially will bring up each figure within a folder automatically and allow the user to click and enter the relevant information about a figure as they go. This information is then all stored in a data frame or list at the end of the process, saving quite a bit of time. Users can stop mid-way through a folder by simply exiting after the last plot they have digitised.  The data from completed figures will automatically be written to the `caldat/` folder for later use and editing, should the user need to do this.

`metaDigitise()` can work on a directory with figures (currently .png, .jpg, .tiff, .pdf images can be used) from many different papers and that are of different types. However, users can get creative in how they set up the directories of figures to facilitate extraction. For example, one might have 3–4 figures from a single paper that need extracting and the user may want to focus on a single paper at a time while the information about a paper is on hand. This could be done by simply setting up a file structure as follows and then using `metaDigitise()` with path names (i.e., the directory) for each papers folder:

```
	* Main project directory
		+ Paper1_P1
			+ Figure1.png
			+ Figure2.png
			+ Figure3.png
		+ Paper2_P2
			+ Figure1.png
			+ Figure2.png
			+ Figure3.png
```
An alternative directory structure (and probably the most flexible) would be to simply have a set of different figures with an informative and relevant naming scheme to make it easy to identify the paper and figure the data come from. This cuts out the need to change directories constantly. For example the directory structure could look like:

```
	* Main project directory
		+ FiguresToExtract
			+ P1_Figure1_trait1.png
			+ P1_Figure2_trait2.png
			+ P1_Figure3_trait3.png
			+ P2_Figure1_trait1.png
			+ P2_Figure2_trait2.png
			+ P2_Figure3_trait3.png
```
The above directory structure is probably the easiest in combination with a clear and unambiguous naming scheme for each figure. Even if only figures from a single paper are digitised, one paper at a time, an overall figure directory will work perfectly because `metaDigitise()` will only cycle through incomplete figures, so figures can be added at anytime. 

Nonetheless, how users set up their directory is really up to them. However, it is important for users to think carefully about reproducibility at this stage. A versatile naming scheme that is consistent across papers and contains the relevant information the user desires will make digitising and sharing much easier if thought through carefully before starting a project.

# Example of how it works <a name="P4"></a>

We'll first demonstrate how `metaDigitise` works when the user simply wants to extract data from a single figure. Here, we'll use the `iris` (loaded in R using `data(iris)`) dataset and some plots from this dataset to demonstrate how it works. In this case, we have an `example_figs/` folder in our meta-analysis project directory and a scatter plot of sepal length and width for two species (setosa and versicolor), which we would like to extract relevant statistics from. We've labeled this file 001_Anderson_1935_Fig1.png. Notice our naming of this file. 001 is the paper number followed by the author, year (in this case the data was collected by E. Anderson in 1935) and the figure number. This makes it easy to keep track of the figures being digitised. Here is what this figure looks like:

<p align="center">
  <img align="centre" src="https://user-images.githubusercontent.com/3505482/32259397-651ea5a6-bf14-11e7-8073-a18aa7bd3094.png" hspace="20" width = "450"/>
</p>

To extract from 001_Anderson_1935_Fig1.png just provide the directory path name of the folder with the image to the `metaDigise()` function:

```
data <- metaDigitise(dir = "~/example_figs/")
```

Here, the output will be stored to the `data` object, which is great because we can access this after we have digitised. The `"~/example_figs/"` just tells the `metaDigitise()` function that we would like to execute the function from the "example_figs/" folder. Throughout the process of digitising `metaDigitise()` walks the user through what to do both before and as the image / figure is being digitised. To start, the first thing a user must do is to tell `metaDigitise()` what you would like to do:

```
Do you want to...

1: Process new images
2: Import existing data
3: Edit existing data

Selection: 
```

All the user needs to enter is the number related to the specific process they would like to execute. In this case, we have not digitised any data yet, and so, if we choose option `2` or `3` it will tell us that there are no digitised objects to work with. So, our only option is `1`, which will allow us to digitise the specific file within this directory.

The next thing we are asked is whether we have different types of plot(s) in the folder. This question is most relevant for a directory with lots of figures (e.g., scatterplots, histograms etc), but we have the same plot type here (scatter plot) and so we specify "s". 

```
Are all plot types Different or the Same? (d/s)
```

We are next asked whether we want to flip or rotate the figure image. This can be needed when box plots and mean and error plots are not orientated correctly. In some cases, older papers can give slightly off angled images which can be corrected by rotating. So, in this prompt the user has three options: `f` for "Flip", `r` for "rotate" or `c` for "continue. For now, our image (which appears on screen in the plotting window), looks fine so we'll hit `c` for now. 

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

Flip, rotate or continue (f/r/c) 
R< c
```

After we do this, `metaDigistise()` will ask the user to specify the plot type. Depending on the figure, the user can specify that it is a figure containing the mean and error (`m`), a box plot (`b`), a scatter plot (`s`) or a histogram (`h`). If the user has specified `d` instead of `s` in response to the question about whether the plot types are the same or different, this question will pop up for each plot, but will only be asked once if plots are all the same.

```
Please specify the plot_type as either:

 m: Mean and error
 b: Box plot
 s: Scatter plot 
 h: Histogram

 R> s
 ```

After selecting the figure type a new set of prompts will come up that will ask the user first what the y and x-axis variables are. This is useful as you can keep track of the different variables across different figures and papers. Here, the user can just add this information in to the R console. Once complete, we'll get prompted to calibrate the x and y-axis so that the relevant statistics / data can be correctly calculated. If we were working with a plot of mean and standard errors, the x-axis is rather useless in terms of calibration so `metaDigitise` just asks the user to calibrate the y-axis (more on that soon). 

```
What is the y variable? Sepal Length (mm)

What is the x variable? Sepal Width (mm)

On the Figure, click IN ORDER: 
      y1, y2 , x1, x2  


    Step 1 ----> Click on known value on y axis - y1
  |
  |
  |
  |
  y1
  |_________________________
  ....

    Step 3 ----> Click on known value on x axis - x1
  |
  |
  |
  |
  |
  |_____x1__________________

  ....
  ```

Follow the instructions on screen step-by-step (instructions above have been truncated by `...` to simplify), and in the order specified. The user will then be asked to specify the x and y calibration points and whether or not the calibration has been set up correctly. If `n` is chosen because something needs to be fixed then the user can re-calibrate.

```
What is the value of y1 ?
R< 4.5
What is the value of y2 ?
R< 7
What is the value of x1 ?
R< 2
What is the value of x2 ?
R< 4

Re-calibrate? (y/n) 
```

The first few questions ask the user what the calibration points are. Often, plots might contain multiple groups that the meta-analyst wants to extract from. `metaDigitise()` handles this nicely by prompting the user to enter the group first, followed by the digitisation of this groups data. After digitising the first group, and having exited (i.e., hit `esc` from plot window), `metaDigitise()` will ask the user whether they would like to add another group. They can add another group (`a`), or simply continue (`c`). The number of groups are not really limited and users can just keep adding in groups to accommodate the different numbers that may be presented across figures (although it can get complicated with too many).

```
Follow instructions below, to exit point adding or removing:

 - Windows: right click on the plot area and choose 'Stop'!

 - X11: hit any mouse button other than the left one.

 - quartz/OS X: hit ESC

Group identifier: setosa

Click on points you want to add.
If you want to remove a point, or are finished with a
group, exit (see above), then follow prompts

Add points, delete points or continue? (a/d/c) 
R< c

```

Once we are done digitising all the groups our plot will look something like this:
<p align="center">
  <img align="centre" src="https://user-images.githubusercontent.com/3505482/32259894-071cdcc6-bf18-11e7-8e19-c8d449f9fe01.png" hspace="20" width = "450"/>
</p>

`metaDigitise()` will conveniently print on the figure the calibration details along with group names and sample sizes. It will also print the figure name, which is useful if the user needs to go back and find the paper to obtain information. Printing this information on the figure is also useful so that input can be checked with actual values on the figure, and any mistakes can then be corrected if found.  Don't worry if you notice a mistake. Prior to exiting the figure you will be prompted with this:

```
Add group, Edit group, Delete group, or Finish plot? (a/e/d/f) 
R< f
```

Choosing `e` allows the user to go back and edit a group already digitised, but also, `d` allows them to completely delete a group and re-digitise if necessary. In our case, all has gone well and we choose `f` to finish plotting. This will exit `metaDigitise()` (since we only have a single figure) and save the summary statistics to the data object that can be conveniently queried by printing the object:

```
 data
                    filename          variable   group_id     mean        sd  n         r         se
1 001_Anderson_1935_Fig1.png  Sepal width (mm)     setosa 3.421871 0.4024572 39 0.7486265 0.06444473
2 001_Anderson_1935_Fig1.png Sepal length (mm)     setosa 4.999651 0.3830298 39 0.7486265 0.06133386
3 001_Anderson_1935_Fig1.png  Sepal width (mm) versicolor 2.765198 0.3233171 44 0.5155360 0.04874189
4 001_Anderson_1935_Fig1.png Sepal length (mm) versicolor 5.950621 0.5290171 44 0.5155360 0.07975232

  error_type   plot_type
1         sd scatterplot
2         sd scatterplot
3         sd scatterplot
4         sd scatterplot

```

Our summary output has all the relevant information about the means, standard deviations and standard errors (if sample size is provided) for each of the variables. The user will notice an `r` column indicating the correlation coefficient between sepal width and length for each species (provided because this is a scatterplot). These match reasonably well with the actual means of Sepal length and width for each of the species in the `iris` dataset:

```
     Species meanSL meanSW
1     setosa  5.006  3.428
2 versicolor  5.936  2.770

```

One thing anyone with a familiarity with the iris dataset will notice is that the sample sizes for each of these species (which are n = 50 each) are quite a bit lower. This is an example of some of the challenges when extracting data from scatter plots, often data points will overlap with each other making it impossible (without having the real data) to know whether this is a problem. However, a meta-analyst will probably realise that the sample sizes here conflict with what is reported in the paper. Hence, we also provide the user with an option to input the sample sizes directly, even for scatterplots and histograms where, strictly speaking, this shouldn't be necessary. Nonetheless, it is important to recognise the impact that overlapping points can have (particularly its effects on SD and SE). In our case, our mean point estimates are nearly bang on, but the SD's are slightly over-estimated:

```
     Species    meanSL    meanSW
1     setosa 0.3524897 0.3790644
2 versicolor 0.5161711 0.3137983

```

While this is a problem for any program digitising from figures, it is probably the best that can be done. However, for reproducibility, all the calibration and raw data is exported to a special folder `caldat/`, which can be brought back in and edited at any time should new information come to light.

# Processing batches of figures of different types <a name="P5"></a>

Often a paper, and especially a single meta-analytic project, contains many figures needing extracting and having to open and re-open new files, save data, analyse or summarize data, make conversions etc. takes up a lot of unnecessary time. `metaDigitise()` solves this problem by gradually working through all files within a directory, allowing users to digitise from them and then save the output from all digitsiations to a single data frame – providing summary statistics by default. `metaDigitise()` automatically does this for the meta-analyst without having to use a different function or special set of arguments. 

Lets assume now that, after digitising our scatter plot, we have added two new figures from a different study done by a research group conducting experiments on the same species. Both figures contain data on sepal length and width for the same species but on a sample taken from different populations. Here, we have added two new figures from this study (002_Doe_2013_Fig1.png and 003_Doe_2013_Fig3.png) to the same folder containing 001_Anderson_1935_Fig1.png. The folder now contains our original scatter plot (completely digitised), but also a mean error plot of the same three species (002_Doe_2013_Fig1.png) along with a histogram of sepal width for a fourth species (003_Doe_2013_Fig3.png -`catana` – a hypothetical species). 

In this specific example, we now have different types of figures (allowing us to demonstrate the flexibility of `metaDigitise()`) in our directory. Here is what our new figures look like:
<p align="center">
  <img src="https://user-images.githubusercontent.com/3505482/32300779-3283752c-bfaf-11e7-9c75-05b2438fa528.png" hspace="20" width = "300"/><img src="https://user-images.githubusercontent.com/3505482/32300780-32b0f218-bfaf-11e7-8d1b-a0618c3b094e.png" hspace="20" width = "300"/>
</p>
Now that we have added two new figures from Doe (2013), our directory looks like this:

```
  *example_figs
      +caldat
          +001_Anderson_1935_Fig1
      +001_Anderson_1935_Fig1.png
      +002_Doe_2013_Fig1.png
      +003_Doe_2013_Fig3.png
```

We have already processed figure (001_Anderson_1935_Fig1.png) and we can tell because it has digitised data (caldat/001_Anderson_1935_Fig1), but now we have our two new figures that have not yet been digitised. This example will nicely demonstrate how users can easily pick up from where they left off and how all previous data gets re-integrated. It will also demonstrate how different plot types are handled. All we have to do to begin, is again, provide the directory where all the figures are located:

```
data <- metaDigitise(dir = "~/example_figs/")

```

Here, we'll get the same prompts as we seen when digitising our scatter plot above. Given we want to process the new files we have, we'll select `1`. All the prompts after this selection are essentially the same, but we now specify that we have different [i.e.,`d`] plots and as the figures are loaded in the plotting window we'll be prompted to specify what type of plot we have on screen. 

```
Are all plot types Different or the Same? (d/s)

R< d

Please specify the plot_type as either:

 m: Mean and error
 b: Box plot
 s: Scatter plot 
 h: Histogram

R> m

**** NEW PLOT ****

mean_error and boxplots should be vertically orientated
       _ 
       |  
  I.E. o    NOT  |-o-|
       |
       _

If they are not then chose flip to correct this.

If figures are wonky, chose rotate.

Otherwise chose continue

Flip, rotate or continue (f/r/c) 

R< c

```

Notice that `metaDigitise()` did not bring back up the scatter plot that we had already digitised. That's because it recognised the `metaDigitise` object for this plot in the `caldat` folder. Here, we specify the new plot type as `m` for mean error because we have a plot of the mean and error of sepal length for each of the three species. We're then prompted a bit differently from our scatter plot as we don't need to use the x-axis for calibration:

```
What is the variable? Sepal length

On the Figure, click IN ORDER: 
      y1, y2  


    Step 1 ----> Click on known value on y axis - y1
  |
  |
  |
  |
  y1
  |_________________________


    Step 2 ----> Click on another known value on y axis - y2
  |
  y2
  |
  |
  |
  |_________________________
  
What is the value of y1 ?
R<5

What is the value of y2 ?
R<6.5

Re-calibrate? (y/n) 
R< n

Enter sample sizes? (y/n) 
R< y

Group identifier: 
R< setosa

Group sample size: 
R< 50

Click on Error Bar, followed by the Mean

Add group, Delete group or Finish plot? (a/d/f)
R< a
```

The prompts, again, tell the user to calibrate the y-axis and enter these calibration values. After this we now have some new prompts, which tells `metaDigitise()` whether we have sample sizes for all the groups in the plot. If `y` we can enter the group name and its sample size straight after. This is important for back calculating standard errors, for example, in this plot. The user can then digitise each of the groups, being prompted after each group whether to add, delete for finish digitising the group. The user can continue adding groups to the plot until they are all completely digitised (see figure below), at which point the user is asked to specify the type of error:

```
Type of error (se, CI95, sd): 

R< se
```

<p align="center">
  <img align="centre" src="https://user-images.githubusercontent.com/3505482/32304001-44c9f164-bfc0-11e7-80c6-d36a1f463c2b.png" hspace="20" width = "450"/>
</p>
When we are done the current plot, because there is another figure left to digitise, we get a message indicating how many figures are left and whether we want to continue. This allows the user to stop or automatically bring up the next figure for processing:

```Do you want continue: 1 plots out of 2 plots remaining (y/n) y```

After selecting `y` the second plot pops up with all the same prompts. Digitising information from histograms is a little bit more involved, however, than other plots because we need to characterize the entire distribution directly. The difference with histograms is that the user needs to click both the left and right corners of each bar, and continue adding until all bars of the histogram have digitised lines above them. The user can just continue clicking each of the bars and `metaDigitise()` will colour code the bars after each bar has been digitised to make it clear how each line corresponds to each bar on the histogram. A number is printed above the bar which is useful for editing as users can just type the bar number they want to change when editing.

<p align="center">
  <img src="https://user-images.githubusercontent.com/3505482/42200754-35550890-7ed8-11e8-8b53-f7343649f2fd.png" hspace="20" width = "450"/>
</p>

Once the user is finished, `metaDigitise()` will sort all the summary data for each of the figures, including the previously digitised figure(s) (001_Anderson_1935_Fig1.png) in the `data` object.

```
data
                   filename          variable        group_id     mean        sd  n         r         se
1 001_Anderson_1935_Fig1.png  Sepal width (mm)          setosa 3.421871 0.4024572 39 0.7486265 0.06444473
2 001_Anderson_1935_Fig1.png Sepal length (mm)          setosa 4.999651 0.3830298 39 0.7486265 0.06133386
3 001_Anderson_1935_Fig1.png  Sepal width (mm)      versicolor 2.765198 0.3233171 44 0.5155360 0.04874189
4 001_Anderson_1935_Fig1.png Sepal length (mm)      versicolor 5.950621 0.5290171 44 0.5155360 0.07975232
5      002_Doe_2013_Fig1.png      Sepal length          setosa 5.000336 0.7828656 50        NA 0.11071391
6      002_Doe_2013_Fig1.png      Sepal length      viriginica 6.588705 1.2608173 50        NA 0.17830649
7      002_Doe_2013_Fig1.png      Sepal length      versicolor 5.941237 1.0125716 50        NA 0.14319926
8      003_Doe_2013_Fig3.png      Sepal length          catana 4.948472 0.3624212 50        NA 0.05125409
  error_type   plot_type
1         sd scatterplot
2         sd scatterplot
3         sd scatterplot
4         sd scatterplot
5         se  mean_error
6         se  mean_error
7         se  mean_error
8         sd   histogram
               
```

Here, the output has all the relevant summary statistics we digitsied for each figure and specifies the plot type. The `caldat` folder also now contains files for the newly digitised figures (see below). We can continue adding and digitising as new figures come up and it will automatically integrate these new statistics into the dataset, which can then be exported using `write.csv(data, file = "filename")` from R.

```
  *example_figs
      + caldat
          + 001_Anderson_1935_Fig1
          + 002_Doe_2013_Fig1
          + 003_Doe_2013_Fig3
      + 001_Anderson_1935_Fig1.png
      + 002_Doe_2013_Fig1.png
      + 003_Doe_2013_Fig3.png
```

One trick to digitising all kinds of figures all at once is to include the figure legends in the image, allowing you to quickly get information that is relevant should you need it as the figures come up. This means the meta-analyst won't need to necessarily go grab and consult the paper for things like sample sizes (often these are in figure legends). 

The fact that `metaDigitise()` only processes and digitises new figures from an image folder means there are two additional benefits afforded to meta-analysts. First, it is easy to update the meta-analysis in the future and integrate all the data together, providing that the image folder and / or project directory is shared. Second, if there are collaborators on the project, if the project folder and images are shared, then co-authors can pick up from where another colleague left off. 

# Re-importing previously digitised data and accessing raw data <a name="P6"></a>

Now that all the relevant figures from papers included in the meta-analysis are digitised we can easily re-import these data if at any point in the future there is a need to view them again. But also, in case we need to get the raw data and process this in a unique way – this may be necessary from scatter plots. Again, this is seamless and easy with `metaDigitise()`:

```
data <- metaDigitise(dir = "~/example_figs/")
```

However, instead of selecting `1` we can just select `2` and import existing files:

```
data <- metaDigitise("~/example_figs/")
Do you want to...

1: Process new images
2: Import existing data
3: Edit existing data

Selection: 2
```

Importantly, this will import the same summary statistics that we seen above, but what if we wanted the raw data because we wanted to access the data for the scatter plot. This is easy by re-specifying the call to the `summary` argument in `metaDigitise` as follows:

```
data <- metaDigitise(dir = "~/example_figs/", summary = FALSE)
```

In this case, `metaDigitise` returns a list with all the relevant data organised into slots that are related to each plot type:

```
List of 3
 $ mean_error :List of 1
  ..$ 002_Doe_2013_Fig1.png:'data.frame': 3 obs. of  5 variables:
  .. ..$ id      : Factor w/ 3 levels "setosa","versicolor",..: 1 2 3
  .. ..$ mean    : num [1:3] 5 5.93 6.59
  .. ..$ error   : num [1:3] 0.111 0.148 0.178
  .. ..$ n       : num [1:3] 50 50 50
  .. ..$ variable: chr [1:3] "Sepal length" "Sepal length" "Sepal length"
 $ hist       :List of 1
  ..$ 003_Doe_2013_Fig3.png:'data.frame': 8 obs. of  3 variables:
  .. ..$ midpoints: num [1:8] 4.3 4.5 4.7 4.9 5.1 ...
  .. ..$ frequency: num [1:8] 4 5 7 12 11 6 2 3
  .. ..$ variable : chr [1:8] "Sepal length" "Sepal length" "Sepal length" "Sepal length" ...
 $ scatterplot:List of 1
  ..$ 001_Anderson_1935_Fig1.png:'data.frame':  83 obs. of  8 variables:
  .. ..$ id        : Factor w/ 2 levels "setosa","versicolor": 1 1 1 1 1 1 1 1 1 1 ...
  .. ..$ x         : num [1:83] 2.3 2.9 3 3 3 ...
  .. ..$ y         : num [1:83] 4.5 4.4 4.41 4.3 4.8 ...
  .. ..$ group     : num [1:83] 1 1 1 1 1 1 1 1 1 1 ...
  .. ..$ col       : Factor w/ 2 levels "red","green": 1 1 1 1 1 1 1 1 1 1 ...
  .. ..$ pch       : num [1:83] 19 19 19 19 19 19 19 19 19 19 ...
  .. ..$ y_variable: chr [1:83] "Sepal length (mm)" "Sepal length (mm)" "Sepal length (mm)" "Sepal length (mm)" ...
  .. ..$ x_variable: chr [1:83] "Sepal width (mm)" "Sepal width (mm)" "Sepal width (mm)" "Sepal width (mm)" ...
```

We can see that all the raw data for our scatter plot is held within this object, and if we wanted to extract this we can easily do so through:

```
anderson <- do.call(rbind, data$scatterplot)

# OR a slightly cleaner version

anderson <- plyr::ldply(data$scatterplot, row.names=FALSE)

```

To get the final scatter plot data back as a data frame:

```
                         id     id        x        y group col pch        y_variable        x_variable 
1 001_Anderson_1935_Fig1.png setosa 2.301216 4.496177     1 red  19 Sepal length (mm)   Sepal width (mm)
2 001_Anderson_1935_Fig1.png setosa 2.900806 4.404945     1 red  19 Sepal length (mm)   Sepal width (mm)
3 001_Anderson_1935_Fig1.png setosa 3.001914 4.407057     1 red  19 Sepal length (mm)   Sepal width (mm)
4 001_Anderson_1935_Fig1.png setosa 3.004389 4.300789     1 red  19 Sepal length (mm)   Sepal width (mm)
5 001_Anderson_1935_Fig1.png setosa 3.003907 4.801037     1 red  19 Sepal length (mm)   Sepal width (mm)
6 001_Anderson_1935_Fig1.png setosa 3.003289 4.904720     1 red  19 Sepal length (mm)   Sepal width (mm)
...
```

We can now do whatever we need with these data as all the x and y values for sepal length and width are available. An alternative way to access the raw data is to use the `getExtracted()` function on the directory as follows:

```
dat <- getExtracted("~/example_figs/", summary = FALSE)
```

Users will then have quick access to the raw or summarised data without the prompts.

# Editing and plotting digitised figures <a name="P7"></a>

A particularly useful feature of `metaDigitise()` is its ability to re-plot previously digitised figures and edit them. Lets assume that for some reason the user noticed that one of the groups in 002_Doe_2013_Fig1.png (versicolor) wasn't quite correctly placed. This can be modified rather simply as follows:

```
data <- metaDigitise("~/example_figs/", summary = TRUE)
Do you want to...

1: Process new images
2: Import existing data
3: Edit existing data

Selection: 3
```

Selecting option `3` will bring up a new set of prompts that provide quite a bit of flexibility for users:

```
Choose how you want to edit files:

1: Cycle through images
2: Choose specific file to edit
3: Enter previously omitted sample sizes

Selection: 2
```
Here, users can choose `1` and `metaDigitise()` will cycle through all the digitised figures, one after the other, re-plotting these in the plotting window and asking the user whether they would like to edit it. This provides a facility with which users can check existing digitisations for all the figures in a folder. Alternatively, if the user would like to add in sample sizes because the sample sizes in a paper were different based on new information, they can simply choose option `3`. However, we only need to edit one figure and option `2` is best in our case because this selection will provide a selection of all the digitised figures:

```
1. 001_Anderson_1935_Fig1 2. 002_Doe_2013_Fig1  3. 003_Doe_2013_Fig3

Select number of file to edit 2
```

The user can then just select the relevant figure that needs editing. After the selection, a similar (but a slightly expanded) set of prompts that would be used to edit during digitisation are provided to walk the user through what specifically they would like to modify:

```
Edit rotation? If yes, then the whole extraction will be redone (y/n) 

R< n

Change plot type? If yes, then the whole extraction will be redone (y/n) 

R< n

Variable entered as: Sepal length
Rename Variables (y/n) 

R< n

Edit calibration? (y/n) 

R< n

Re-extract data (y/n) 

R< y

Change group identifier? (y/n) 

R< n

Add group, Delete group or Finish plot? (a/d/f) 

R< d

1: setosa
2: versicolor
3: viriginica

Selection: 2
Add group, Delete group or Finish plot? (a/d/f) 

R< a

Group identifier: 

R< versicolor_edit

Group sample size: 

R< 50

Click on Error Bar, followed by the Mean

Add group, Delete group or Finish plot? (a/d/f) 

R< f

Type of error: 

R< se

Re-enter error type (y/n) 

R< n
```

This provides lots of flexibility to edit various aspects of previously digitised functions. This then integrates this corrected data directly into the fully formed data summary and re-writes the .RDS file in the `caldat/` folder automatically.
<p align="center">
  <img src="https://user-images.githubusercontent.com/3505482/32355606-b2e9d5d8-c083-11e7-84cc-8a460c9403c2.png" hspace="20" width = "380"/><img src="https://user-images.githubusercontent.com/3505482/32304001-44c9f164-bfc0-11e7-80c6-d36a1f463c2b.png" hspace="20" width = "380"/>
</p>
Above, we have just slightly modified versicolor's point to make it overlap a bit better with the black dot. And we can see the slight change in this value:

```
                   filename          variable        group_id     mean        sd  n         r         se
1 001_Anderson_1935_Fig1.png  Sepal width (mm)          setosa 3.421871 0.4024572 39 0.7486265 0.06444473
2 001_Anderson_1935_Fig1.png Sepal length (mm)          setosa 4.999651 0.3830298 39 0.7486265 0.06133386
3 001_Anderson_1935_Fig1.png  Sepal width (mm)      versicolor 2.765198 0.3233171 44 0.5155360 0.04874189
4 001_Anderson_1935_Fig1.png Sepal length (mm)      versicolor 5.950621 0.5290171 44 0.5155360 0.07975232
5      002_Doe_2013_Fig1.png      Sepal length          setosa 5.000336 0.7828656 50        NA 0.11071391
6      002_Doe_2013_Fig1.png      Sepal length      viriginica 6.588705 1.2608173 50        NA 0.17830649
7      002_Doe_2013_Fig1.png      Sepal length versicolor_edit 5.942371 1.0125716 50        NA 0.14319926
8      003_Doe_2013_Fig3.png      Sepal length          catana 4.948472 0.3624212 50        NA 0.05125409
  error_type   plot_type
1         sd scatterplot
2         sd scatterplot
3         sd scatterplot
4         sd scatterplot
5         se  mean_error
6         se  mean_error
7         se  mean_error
8         sd   histogram

```

We can see from above that the edit has been integrated (remember we re-named `versicolor` to `versicolor_edit`). These changes have now also re-written the `metaDigitise` object to the `caldat/` folder. Note here, whether the user clicks the lower or upper error bar, it doesn't matter (we've done this to make our changes stand out in the figures above). 

Another useful feature is the ability to add sample sizes *after* digitising. The meta-analyst may not have the sample size information on hand at the time, or it maybe unclear from the paper and they may need to email authors.  Not to worry, users can add this information to any paper missing sample sizes after the fact and all summary statistics will be correctly calculated. Users just need to choose option `3` in the editing window:

```
Choose how you want to edit files:

1: Cycle through images
2: Choose specific file to edit
3: Enter previously omitted sample sizes

Selection: 3
```

In this case, we have been fortunate enough to have all the sample sizes handy and so it tells us:

```
**** No files need N ****
```

However, if some files were missing we would see a list of files that we could choose from to enter the sample sizes in. If we only had SE for that particular figure, then we wouldn't have been able to calculate SD without N. Hence, SD would be `NA` in the data. After entering sample sizes, we can now calculate SD from SE and N and so `metaDigitise()` will do this and re-incorporate the changes.

# Conclusions <a name="Conclusion"></a>

We are still actively developing the `metaDigitise` package and would be more than happy to hear what you think of it, if you have suggestions for possible improvements or find any bugs. Please lodge an issue and we can try and deal with these as soon as possible. Also, feel free to email the package maintainers. Our future plans include arguments for calculating standard deviations from 95`%` confidence intervals and standard errors using the t-distribution to correct the t-value for small sample sizes (currently assumed t-values are 1.96 as is normal), dealing with asymmetric error bars and the possibility of zooming in plots such that greater accuracy can be achieved when digitising. We hope to also provide options for assessing inter-observer reliability in the future.


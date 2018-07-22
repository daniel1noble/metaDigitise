#' @title metaDigitise
#' @description Single or batch processing of figures with .png, .jpg, .tiff, .pdf extensions within a set directory. metaDigitise() consolidates the data and exports the data for each image and image type. It can also summarise the data, provide the raw data (if scatterplots) and automatically imports previously finished data and merges it with newly digitised data. metaDigitise() also allows users to check their calibration along with editing previous digitisations.
#' @param dir the path name to the directory / folder where the files are located
#' @param summary whether the digitised data should be returned as a summary (TRUE) or as a concatenated list of similar types.
#' @param cex relative size of points and text in replotting of digitisation. Default is 1.
#' @details metaDigitise() can be used on a directory with a whole host of different figure types (mean and error, scatter plots, box plots and histograms) and file types (.jpeg, .png, .tiff, .pdf). There are three major options provided to users:
#' 
#' If the "1: Process new images" option is chosen, it will automatically cycle through all figures not already completed within a directory in order, prompting the user for specific information as they go. At the end of each figure users will be asked if they would like to continue or not, providing flexibility to leave a job should should they need to. As figures are digitised it will automatically write metaDigitise() object files (in .RDS format containing processed and calibration data along with directory and file details), into a special caldat/ folder within the directory. Importantly, as new files are added to a directory that has already been "completed", metaDigitise() will recognize these unfinished files and only cycle through the digitisation of these new files. This easily allows users to pick up from where they left off. It will also automatically re-merge completed figure with any newly digitised figures at the end of this process keeping everything together throughout the process.
#' 
#' If the "2: Import existing data" is chosen, all existing files that have already been digitised will be automatically imported from the given directory. 
#' 
#' Finally, metDigitise is built for ease of editing and reproducibility in mind. Hence, if "3: Edit existing data" is chosen by the user then users will have the options to "1: Cycle through images" (that are complete), overlaying digitisations with each figure and asking whether they would like to edit each figure or "2: Choose specific file to edit" allowing editing for a specific file. Here a list of all files are provided and the user simply needs to pick the one in the console they would like to view. Alternatively, the "3: Enter previously omitted sample sizes" option allows the user to go back and enter sample sizes that they may not have had on hand at the time of digitisation. This means that, so long as the caldat/ folder along with respective images are maintained, anyone using metaDigitise() can simply import existing digitisations, modify them and fix them. This folder can then be shared with colleagues to allow them to reproduce any data extraction.
#' @author Joel Pick - joel.l.pick@gmail.com
#' @author Daniel Noble - daniel.wa.noble@gmail.com
#' @return A data frame or list containing the raw digitised data or the processed, summary statistics from the digitised data
#' @examples
#' \donttest{
#' # temporary directory
#' tmp_dir <- tempdir()
#' 
#' # Simulate data
#' set.seed(103)
#' x <- rnorm(20,0,1)
#' y <- rnorm(20,0,1)
#' means <- c(mean(x),mean(y))
#' ses <- c(sd(x)/sqrt(length(x))*1.96, sd(y)/sqrt(length(y))*1.96)
#' 
#' #Generate mock figures
#' png(filename = paste0(tmp_dir,"/mean_error.png"), width = 480, height = 480)
#' plot(means, ylim = c(min(means-ses)-0.1,max(means+ses)+0.1), xlim=c(0.5,2.5), 
#' xaxt="n", pch=19, cex=2, ylab="Variable +/- SE", xlab="Treatment", main="Mean Error")
#' arrows(1:length(means),means+ses, 1:length(means), means-ses, code=3, angle=90, length=0.1)
#' axis(1,1:length(means),names(means))
#' dev.off()
#' png(filename = paste0(tmp_dir, "/boxplot.png"), width = 480, height = 480)
#' boxplot(x,y, main="Boxplot")
#' dev.off()
#' png(filename = paste0(tmp_dir, "/histogram.png"),width = 480, height = 480)
#' hist(c(x,y), xlab= "variable", main="Histogram")
#' dev.off()
#' png(filename = paste0(tmp_dir, "/scatterplot.png"), width = 480, height = 480)
#' plot(x,y, main="Scatterplot")
#' dev.off()
#' 
#' #metaDigitise figures
#' \dontrun{
#' data <- metaDigitise(tmp_dir)
#' }
#' }
#' @export

metaDigitise<-function(dir, summary = TRUE, cex=1){
		# Check dir has a / at the end.
	if( (substring(dir, nchar(dir)) == "/") == FALSE){
		dir <- paste0(dir, "/")
	}

	cat("\nDo you want to...\n")
	
	Q <- utils::menu(c("Process new images", "Import existing data", "Edit existing data"))
	
	switch(Q, process_new_files(dir, summary = summary,cex=cex), import_menu(dir, summary = summary), bulk_edit(dir, summary = summary,cex=cex))

}


#' @title process_new_files
#' @description Batch processes image files within a set directory, consolidates the data and exports the data for each image and type
#' @param dir the path name to the directory / folder where the files are located
#' @param summary summary = TRUE or FALSE is most relevant as it will print a simple summary statistics that are the same across all files
#' @param cex relative size of points and text in replotting of digitisation.
#' @author Joel Pick - joel.l.pick@gmail.com
#' @author Daniel Noble - daniel.wa.noble@gmail.com
#' @examples
#' \donttest{
#' # temporary directory
#' tmp_dir <- tempdir()
#' 
#' # Simulate data
#' set.seed(103)
#' x <- rnorm(20,0,1)
#' y <- rnorm(20,0,1)
#' means <- c(mean(x),mean(y))
#' ses <- c(sd(x)/sqrt(length(x))*1.96, sd(y)/sqrt(length(y))*1.96)
#' 
#' #Generate mock mean error plot
#' png(filename = paste0(tmp_dir,"/mean_error.png"), width = 480, height = 480)
#' plot(means, ylim = c(min(means-ses)-0.1,max(means+ses)+0.1), xlim=c(0.5,2.5), 
#' xaxt="n", pch=19, cex=2, ylab="Variable +/- SE", xlab="Treatment", main="Mean Error")
#' arrows(1:length(means),means+ses, 1:length(means), means-ses, code=3, angle=90, length=0.1)
#' axis(1,1:length(means),names(means))
#' dev.off()
#' 
#' \dontrun{
#' #metaDigitise figures
#' 	data <- process_new_files(paste0(tmp_dir, "/"), summary = TRUE, cex = 2)
#' }
#' }
#' @export
process_new_files <- function(dir, summary = TRUE, cex) {

	# Set up calibration directory, obtain all the file details within a directory and ascertain which files need to still be completed. Just grabs relevant metadata
			       setup_calibration_dir(dir)
			      done_details <- dir_details(dir)
	     details <- get_notDone_file_details(dir)
		   type <- user_options("\nAre all plot types Different or the Same? (d/s)" , c("d", "s"))
	
	# If there are completed digitised files within the caldat folder load these metaDigitise objects so that they can be appended at the end of the session with the new digitised data. If there are no completed files these objects simply inherit NULL
	if(length(done_details$calibrations) >= 1){	
		done_objects <- load_metaDigitise(done_details$doneCalFiles, done_details$names)
		done_plot_types <- lapply(done_objects, function(x) x$plot_type)
		names <- lapply(done_objects, function(x) filename(x$image_file))
		names(done_plot_types) <- names
	} else{
		done_objects = NULL
		done_plot_types = NULL
		names = NULL
	}

	# Ask whether the plots are different or the same to avoid prompting if all the same when digitising
	 plot_types <-  if (type == "d") {NULL} else { specify_type() }
	
	# Create data list to store previous and current digitisations of figures
		 data_list <- list()

	# Loops from all non-completed figures and allow users to digitise. Save the calibration and raw data to the caldat folder
		 for (i in 1:length(details$paths)) {
			         data_list[[i]] <- internal_digitise(details$paths[i], plot_type = plot_types, cex=cex)	
			    names(data_list)[i] <- details$images[i]
			 saveRDS(data_list[[i]], file = paste0(details$cal_dir, details$name[i]))
			
			if(length(details$paths)-i>0){
				breakQ <-  user_options(paste("\n\nDo you want continue:", length(details$paths)- i, "plots out of", length(details$paths), "plots remaining (y/n) "), c("y","n"))
				if(breakQ=="n") break
			}else{
				cat("\nCongratulations! Looks like you have finished digitising all figures in this directory.\n")
			}
		 }
	
		complete_plot_types <- lapply(data_list, function(x) x$plot_type)

		if( length(done_plot_types) == 0){
			plot_type <- complete_plot_types
		} else{
			plot_type <- c(done_plot_types, complete_plot_types)
		}

	# Depending on summary argument, build the final data. If Summary ==TRUE then create condensed summary statistics. If FALSE, then create a list of the raw data grouped by plot type.
	if(summary == TRUE){
		if(length(done_objects) == 0){
			sum_dat <- do.call(rbind, lapply(data_list, function(x) summary(x)))
			rownames(sum_dat) <- 1:nrow(sum_dat)
			return(sum_dat)
		} else{
			sum_dat <- do.call(rbind, c(lapply(done_objects, function(x) summary(x)), lapply(data_list, function(x) summary(x))))
			rownames(sum_dat) <- 1:nrow(sum_dat)
			return(sum_dat)
		}

	}else{
		if(length(done_objects) == 0){
				new_figs <- extract_digitised(data_list, summary = summary)
				return(new_figs)

		} else{
				done_figs <- extract_digitised(done_objects,  summary = summary)
				new_figs <- extract_digitised(data_list, summary = summary)
			return(order_lists(c(done_figs, new_figs), plot_types = plot_type))
		}
	}

}

#' @title specify_type
#' @description Function that allows user to interface with function to specific each type of plot prior to digitising
#' @return The function will return the type of plot specified by the user and feed this argument back into metDigitise 
#' @author Daniel Noble - daniel.wa.noble@gmail.com
#' @author Joel Pick - joel.l.pick@gmail.com

specify_type <- function(){
		#User enters numeric value to specify the plot BEFORE moving on
	 	pl_type <- NA
	 	#While keeps asking the user the question until the input is one of the options
		while(!pl_type %in% c("m","b","s","h")) pl_type <- readline("\nPlease specify the plot_type as either:\n\n m: Mean and error\n b: Box plot\n s: Scatter plot \n h: Histogram\n\n ")
	
	 	plot_type <- ifelse(pl_type == "m", "mean_error", ifelse(pl_type == "b", "boxplot",ifelse(pl_type == "s", "scatterplot","histogram")))
	
	return(plot_type)
}

#' @title extract_digitised
#' @param list A list of objects returned from metaDigitise
#' @param summary A logical 'TRUE' or 'FALSE' indicating whether metaDigitise should print summary statistics from each figure and group.
#' @description Function for extracting the data from a metaDigitise list and creating either summary data or a list of the raw data.
#' @return The function will return a data frame with the data across all the digitised files 

extract_digitised <- function(list, summary = TRUE) {

	if(summary == TRUE) {
		data <- do.call(rbind, lapply (list, function(x) summary(x)))
		rownames(data) <- 1:nrow(data)
		return(data)
	} else {
		tmp <- lapply (list, function(x) x$processed_data)
		names(tmp) <- unlist(lapply(list, function(x) filename(x$image_file)))
		return(tmp)
	}
}

#' @title setup_calibration_dir
#' @param dir Path name to the directory / folder where the files are located.
#' @description Function will check whether the calibration directory has been setup and if not, create one. 
#' @return Returns a caldat/ folder within the directory where all metaDigitise objects are stored.
#' @author Daniel Noble - daniel.wa.noble@gmail.com
#' @examples
#' \donttest{
#' # temporary directory
#' tmp_dir <- tempdir()
#' 
#' #Create the calibration folder in the directory specified that is used to store files.
#' setup_calibration_dir(paste0(tmp_dir, "/"))
#'
#' }
#' @export

setup_calibration_dir <- function(dir){

	cal_dir <- paste0(dir, "caldat")

	if (dir.exists(cal_dir) == FALSE){
		dir.create(cal_dir)
	}
}

#' @title get_notDone_file_details
#' @param dir Path name to the directory / folder where the figure files are located.
#' @description Function will get file information from the directory and the calibration files. It will also exclude files that have already been processed, as is judged by the match between file names in the calibration folder and the imported details object
#' @return Returns a list containing details on the images names and their paths, the calibration file names (or files already completed) as well as the paths to these files.
#' @author Daniel Noble - daniel.wa.noble@gmail.com
#' @examples
#' \donttest{
#' # temporary directory
#' tmp_dir <- tempdir()
#' 
#' # Simulate data
#' set.seed(103)
#' x <- rnorm(20,0,1)
#' y <- rnorm(20,0,1)
#' means <- c(mean(x),mean(y))
#' ses <- c(sd(x)/sqrt(length(x))*1.96, sd(y)/sqrt(length(y))*1.96)
#' 
#' #Generate mock figures
#' png(filename = paste0(tmp_dir,"/mean_error.png"), width = 480, height = 480)
#' plot(means, ylim = c(min(means-ses)-0.1,max(means+ses)+0.1), xlim=c(0.5,2.5), 
#' xaxt="n", pch=19, cex=2, ylab="Variable +/- SE", xlab="Treatment", main="Mean Error")
#' arrows(1:length(means),means+ses, 1:length(means), means-ses, code=3, angle=90, length=0.1)
#' axis(1,1:length(means),names(means))
#' dev.off()
#' png(filename = paste0(tmp_dir, "/boxplot.png"), width = 480, height = 480)
#' boxplot(x,y, main="Boxplot")
#' dev.off()
#' png(filename = paste0(tmp_dir, "/histogram.png"),width = 480, height = 480)
#' hist(c(x,y), xlab= "variable", main="Histogram")
#' dev.off()
#' png(filename = paste0(tmp_dir, "/scatterplot.png"), width = 480, height = 480)
#' plot(x,y, main="Scatterplot")
#' dev.off()
#' 
#' #Obtain file names that are incomplete within the tmp directory
#' data <- get_notDone_file_details(tmp_dir)
#' }
#' @export

get_notDone_file_details <- function(dir){
	
	details <- dir_details(dir)

	if(!any(!details$name %in% details$calibrations)) {
		stop("\r Congratulations! Looks like you have finished digitising all figures in this directory.\n", call. = FALSE)
	}

	# Find what files are already done. Remove these from our list
	if (length(details$calibrations) >= 1){
		done_figures <- details$name %in% details$calibrations

		# Remove the files that are already done.
		details$images <- details$images[!done_figures]
		details$name <- details$name[!done_figures]
		details$paths <- details$paths[!done_figures]
	}


	return(details)
}

#' @title dir_details
#' @param dir the path name to the directory / folder where the files are located
#' @description Function will gather important directory details about calibration files and figures needed for processing
#' @author Daniel Noble - daniel.wa.noble@gmail.com
#' @examples
#'  \donttest{
#' # temporary directory
#' tmp_dir <- tempdir()
#' 
#' setup_calibration_dir(paste0(tmp_dir, "/"))
#' 
#' # Simulate data
#' set.seed(103)
#' x <- rnorm(20,0,1)
#' y <- rnorm(20,0,1)
#' means <- c(mean(x),mean(y))
#' ses <- c(sd(x)/sqrt(length(x))*1.96, sd(y)/sqrt(length(y))*1.96)
#' 
#' #Generate mock figures
#' png(filename = paste0(tmp_dir,"/mean_error.png"), width = 480, height = 480)
#' plot(means, ylim = c(min(means-ses)-0.1,max(means+ses)+0.1), xlim=c(0.5,2.5), 
#' xaxt="n", pch=19, cex=2, ylab="Variable +/- SE", xlab="Treatment", main="Mean Error")
#' arrows(1:length(means),means+ses, 1:length(means), means-ses, code=3, angle=90, length=0.1)
#' axis(1,1:length(means),names(means))
#' dev.off()
#' png(filename = paste0(tmp_dir, "/boxplot.png"), width = 480, height = 480)
#' boxplot(x,y, main="Boxplot")
#' dev.off()
#' png(filename = paste0(tmp_dir, "/histogram.png"),width = 480, height = 480)
#' hist(c(x,y), xlab= "variable", main="Histogram")
#' dev.off()
#' png(filename = paste0(tmp_dir, "/scatterplot.png"), width = 480, height = 480)
#' plot(x,y, main="Scatterplot")
#' dev.off()
#' 
#' #Obtain details on directory structure that are used for metaDigitise
#' data <- dir_details(tmp_dir)
#' }
#' @export

dir_details <- function(dir){
	detail_list <- list()
#	file_pattern <- "[.][pjt][dnip][fpg]*$"
	file_pattern <- "(?i)[.][pjt][dnip][efpg]*$"
		  detail_list$images <- list.files(dir, pattern = file_pattern)
		    detail_list$name <- gsub(file_pattern, "", detail_list$images)
	       detail_list$paths <- paste0(dir, detail_list$images)
	     detail_list$cal_dir <- paste0(dir, "caldat/")
	detail_list$calibrations <- list.files(paste0(dir, "caldat/"))
	detail_list$doneCalFiles <- if(length(detail_list$calibrations)==0) { vector(mode="character") 
	} else{ 
		paste0(detail_list$cal_dir, detail_list$calibrations) 
	}

	return(detail_list)
}
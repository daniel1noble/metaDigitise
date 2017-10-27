#' @title metaDigitise
#' @description Batch processes png files within a set directory, consolidates the data and exports the data for each image and type
#' @param dir the path name to the directory / folder where the files are located
#' @param types Argument specifying whether the types of images are the same (i.e., all scatter plots - "same") or a mixture of different plot types (i.e., scatter plots, means and se - "diff").
#' @param ... Other arguments called to metaDigitise. summary = TRUE or FALSE is most relevant as it will print a simple summary statistics that are the same across all files.
#' @details 
#' metaDigitise can be used on a directory with a whole host of different figure (mean and error, scatter plots, box plots and histograms) and file types (.jpeg, .png, .tiff, .pdf). It will automatically cycle through all files within a directory in order, prompting the user for specific information as they go. It will also write calibration files (also containing processed data), into a special caldat/ folder within the directory. Importantly, as new files are added to a directory that has already been "completed", metaDigitise will recognize these unfinished files and only cycle through the digitisation of these new files. 
#' @examples
#' # data <- metaDigitise(dir = "./example_figs/", types = "diff", summary = TRUE)
#' # summary(data)
#' @return If type = "same" the function returns a dataframe with the relevant data for each figure being digitised. If type = "diff" it returns a list of the relevant data. If summary = TRUE a tidy version of the above is provided instead.
#' @export

metaDigitise<-function(dir, summary = TRUE){
	cat("Do you want to...\n")
	Q <- menu(c("Process new images", "Import existing data", "Edit existing data"))
	switch(Q, process_new_files(dir, summary = summary), import_metaDigitise(dir, summary = summary), bulk_edit(dir, summary = summary))
}


#' @title process_new_files
#' @description Batch processes png files within a set directory, consolidates the data and exports the data for each image and type
#' @param dir the path name to the directory / folder where the files are located
#' @param summary summary = TRUE or FALSE is most relevant as it will print a simple summary statistics that are the same across all files
#' @export
process_new_files <- function(dir, summary = TRUE) {

			       setup_calibration_dir(dir)
	    details <- get_notDone_file_details(dir)
	DoneDetails <- dir_details(dir)
		   type <- user_options("Are all plot types the same? (diff/same)" , c("diff", "same"))
	
	if(length(DoneDetails$calibrations) >= 1){
		import_data <- import_metaDigitise(dir, summary = summary)
	}

	 plot_type <-  if (type == "diff") {NULL} else{ specify_type() }
		 
		 data_list <- list()

		 for (i in 1:length(details$paths)) {
			         data_list[[i]] <- internal_digitise(details$paths[i], plot_type = plot_type)	
			    names(data_list)[i] <- details$images[i]
			 saveRDS(data_list[[i]], file = paste0(details$cal_dir, details$name[i]))
			breakQ <-  user_options(paste("Do you want continue:", length(details$paths)- i, "plots out of", length(details$paths), "plots remaining (y/n) "), c("y","n"))
		 	if(breakQ=="n") break
		 }
	
		return(list(import_data, extract_digitised(data_list, types = type, summary = summary)))
}

#' @title specify_type
#' @description Function that allows user to interface with function to specific each type of plot prior to digitising
#' @return The function will return the type of plot specified by the user and feed this argument back into metDigitise 
#' @export

specify_type <- function(){
		#user enters numeric value to specify the plot BEFORE moving on
	 	pl_type <- NA
	 	#while keeps asking the user the question until the input is one of the options
		while(!pl_type %in% c("m","b","s","h")) pl_type <- readline("Please specify the plot_type as either: mean and error, box plot, scatter plot or histogram m/b/s/h: ")
	
	 	plot_type <- ifelse(pl_type == "m", "mean_error", ifelse(pl_type == "b", "boxplot",ifelse(pl_type == "s", "scatterplot","histogram")))
	
	return(plot_type)
}

#' @title extract_digitised
#' @param list A list of objects returned from metaDigitise
#' @param summary A logical 'TRUE' or 'FALSE' indicating whether metaDigitise should print summary statitics from each figure and group.
#' @param types Whether the plots are the same or different types
#' @description Function for extracting the data from a metaDigitise list
#' @return The function will return a data frame with the data across all the digitised files 
#' @export

extract_digitised <- function(list, types = c("same", "diff"), summary = TRUE) {

	if(summary == TRUE) {
		data <- do.call(rbind, lapply (list, function(x) summary(x)))
		rownames(data) <- 1:nrow(data)
		return(data)
	}

	if(types == "same"){
		return( do.call (rbind, lapply (list, function(x) x$processed_data)))
	} else {
		return(lapply (list, function(x) x$processed_data))
	}
}

#' @title setup_calibration_dir
#' @param dir the path name to the directory / folder where the files are located
#' @description Function will check whether the calibration directory has been setup and if not, create one. 

setup_calibration_dir <- function(dir){

	cal_dir <- paste0(dir, "caldat")

	if (dir.exists(cal_dir) == FALSE){
		dir.create(cal_dir)
	}
}

#' @title get_notDone_file_details
#' @param dir the path name to the directory / folder where the files are located
#' @description Function will get a series of file information from the directory and the calibration files. It will also exclude files that have already been processed, as is judged by the match between file names in the calibration folder and the 
get_notDone_file_details <- function(dir){
	
	      details <- dir_details(dir)

	# Check whether there are new files still needing to be done.

	if(length(details$calibrations) == length(details$name)) {
		stop("Congratulations! Looks like you have finished digitising all figures in this directory. If you haven't please delete files from the caldat/ folder and try again!", call. = FALSE)
	}

	# Find what files are already done. Remove these from our list
	if (length(details$calibrations) >= 1){
		done_figures <- match(details$calibrations, details$name)
	
	# Remove the files that are already done.
		details$images <- details$images[-done_figures]
		  details$name <- details$name[-done_figures]
		 details$paths <- details$paths[-done_figures]
	}

	return(details)
}

#' @title dir_details
#' @param dir the path name to the directory / folder where the files are located
#' @description Function will gather important directory details about calibration files and figures needed for processing
#' @export
dir_details <- function(dir){
	detail_list <- list()

		  detail_list$images <- list.files(dir, pattern = ".[pjt][dnip][fpg]*")
		    detail_list$name <- gsub(".[pjt][dnip][fpg]*", "", detail_list$images)
	       detail_list$paths <- paste0(dir, detail_list$images)
	     detail_list$cal_dir <- paste0(dir, "caldat/")
	detail_list$calibrations <- list.files(paste0(dir, "caldat/"))
	detail_list$doneCalFiles <- paste0(detail_list$cal_dir, detail_list$calibrations)

	return(detail_list)
}
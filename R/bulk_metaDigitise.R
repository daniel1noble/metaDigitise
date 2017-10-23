#' @title bulk_digitise
#' @description Batch processes png files within a set directory, consolidates the data and exports the data for each image and type
#' @param dir the path name to the directory / folder where the files are located
#' @param types Argument specifying whether the types of images are the same (i.e., all scatter plots - "same") or a mixture of different plot types (i.e., scatter plots, means and se - "diff").
#' @param ... Other arguments called from metaDigitise. summary = TRUE or FALSE is most relevant as it will print a simple summary statistics that are the same across all files.
#' @return If type = "same" the function returns a dataframe with the relevant data for each figure being digitised. If type = "diff" it returns a list of the relevant data.
#' @export

bulk_metaDigitise <- function(dir, types = c("diff", "same"), ...) {
	
	   type <- match.arg(types)
			   setup_calibration_dir(dir)
	details <- get_notDone_file_details(dir)

	 plot_type <-  if (type == "diff") {NULL} else{ specify_type() }
		 
		 data_list <- list()

		 for (i in 1:length(details$paths)) {
			         data_list[[i]] <- metaDigitise(details$paths[i],plot_type = plot_type)			 
			    names(data_list)[i] <- details$images[i]
			 saveRDS(data_list[[i]], file = paste0(details$cal_dir, details$name[i]))
		 }
	

	if (type == "diff") {
		
		return(extract_digitised(data_list, ...))

	} else{
		
		return(do.call(rbind, extract_digitised(data_list, ...)))
	}
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
#' @description Function for extracting the data from a metaDigitise list
#' @return The function will return a data frame with the data across all the digitised files 
#' @export

extract_digitised <- function(list, summary = FALSE) {

	if(summary == TRUE) {
		return( do.call (rbind, lapply (list, function(x) summary(x)) ))		
	} else{
		return( do.call (rbind, lapply (list, function(x) x$processed_data) ))
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
	
	      images <- list.files(dir, pattern = ".[pjt][dnip][fpg]*")
	        name <- gsub(".[pjt][dnip][fpg]*", "", images)
	       paths <- paste0(dir, images)
	     cal_dir <- paste0(dir, "caldat/")
	calibrations <- list.files(paste0(dir, "caldat/"))

	# Check whether there are new files still needing to be done.

	if(length(calibrations) == length(name)) {
		stop("Congratulations! Looks like you have finished digitising all figures in this directory. If you haven't please delete files from the caldat/ folder and try again!", call. = FALSE)
	}

	# Find what files are already done. Remove these from our list
	if (length(calibrations) > 1){
		done_figures <- match(calibrations, name)
	
	# Remove the files that are already done.
		images <- images[-done_figures]
		  name <- name[-done_figures]
		 paths <- paths[-done_figures]
	}

	return(list(images = images, name = name, paths = paths, cal_dir = cal_dir, calibrations = calibrations))
}

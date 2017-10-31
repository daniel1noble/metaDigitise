#' @title metaDigitise
#' @description Single or batch processing of figures with .png, .jpg, .tiff, .pdf extensions within a set directory. metaDigitise consolidates the data and exports the data for each image and image type. It can also summarise the data, provide the raw data (if scatterplots) and automatically imports previously finished data and merges it with newly digitised data. metaDigitise also allows users to check their calibration along with editing previous digitisations.
#' @param dir the path name to the directory / folder where the files are located
#' @param summary whether the digitised data should be returned as a summary (TRUE) or as a concatenated list of similar types. 
#' @details metaDigitise can be used on a directory with a whole host of different figure types (mean and error, scatter plots, box plots and histograms) and file types (.jpeg, .png, .tiff, .pdf). It will automatically cycle through all files within a directory in order, prompting the user for specific information as they go. It will automatically write metaDigitise object files (in .RDS format containing processed and calibration data along with directory and file details), into a special caldat/ folder within the directory. Importantly, as new files are added to a directory that has already been "completed", metaDigitise will recognize these unfinished files and only cycle through the digitisation of these new files. metDigitise is built for reproducibility and ease of operation. This means that, so long as the caldat/ folder along with respective images are maintained, anyone using metaDigitise can simply import existing digitisations, modify them and fix them. 
#' @author {Joel Pick - joel.l.pick@gmail.com; Daniel Noble - daniel.wa.noble@gmail.com}
#' @examples
#' # data <- metaDigitise(dir = "./example_figs/", summary = TRUE)
#' # summary(data)
#' @return A data frame or list containing the raw digitised data or the processed, summary statistics from the digitised data
#' @export

metaDigitise<-function(dir, summary = TRUE){
		# Check dir has a / at the end.
	if( (substring(dir, nchar(dir)) == "/") == FALSE){
		dir <- paste0(dir, "/")
	}

	cat("Do you want to...\n")
	
	Q <- menu(c("Process new images", "Import existing data", "Edit existing data"))
	
	switch(Q, process_new_files(dir, summary = summary), import_metaDigitise(dir, summary = summary), bulk_edit(dir, summary = summary))
}


#' @title process_new_files
#' @description Batch processes image files within a set directory, consolidates the data and exports the data for each image and type
#' @param dir the path name to the directory / folder where the files are located
#' @param summary summary = TRUE or FALSE is most relevant as it will print a simple summary statistics that are the same across all files
#' @author Joel Pick - joel.l.pick@gmail.com; Daniel Noble - daniel.wa.noble@gmail.com
#' @export
process_new_files <- function(dir, summary = TRUE) {

			       setup_calibration_dir(dir)
			      done_details <- dir_details(dir)
	     details <- get_notDone_file_details(dir)
		   type <- user_options("Are all plot types the same? (diff/same)\n" , c("diff", "same"))
	
	if(length(done_details$calibrations) >= 1){	
		done_objects <- load_metaDigitise(done_details$doneCalFiles, done_details$names)
		done_plot_types <- lapply(done_objects, function(x) x$plot_type)
	} else{
		done_plot_types = 0
	}

	 plot_types <-  if (type == "diff") {NULL} else { specify_type() }
		 
		 data_list <- list()

		 for (i in 1:length(details$paths)) {
			         data_list[[i]] <- internal_digitise(details$paths[i], plot_type = plot_types)	
			    names(data_list)[i] <- details$images[i]
			 saveRDS(data_list[[i]], file = paste0(details$cal_dir, details$name[i]))
			breakQ <-  user_options(paste("\n\nDo you want continue:", length(details$paths)- i, "plots out of", length(details$paths), "plots remaining (y/n) "), c("y","n"))
		 	if(breakQ=="n") break
		 }
	
		complete_plot_types <- lapply(data_list, function(x) x$plot_type)

		if( done_plot_types >= 1){
			plot_type <- c(done_plot_types, complete_plot_types)
		} else{
			plot_type <- complete_plot_types
		}

	if(summary == TRUE){

		return(do.call(rbind, list(summary(done_objects), summary(data_list))))

	}else{
			done_figs <- extract_digitised(done_objects,  summary = summary)
			new_figs <- extract_digitised(data_list, summary = summary)
		return(order_lists(c(done_figs, new_figs), plot_types = plot_type))
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
	detail_list$doneCalFiles <- if(length(detail_list$calibrations)==0) { vector(mode="character") 
	} else{ 
		paste0(detail_list$cal_dir, detail_list$calibrations) 
	}

	return(detail_list)
}
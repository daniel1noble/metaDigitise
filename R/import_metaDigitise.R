#' @title import_metaDigitise
#' @description Imports metaDigitise calibration files from a directory that is partially or fully digitised already
#' @param dir The directory where figures have already been digitised
#' @param summary Logical indicating whether the imported data should be returned in summarised form ('TRUE') or not ('FALSE')
#' @return Returns a list (summary = FALSE) or data frame (summary = TRUE)
#' @export

import_metaDigitise <- function(dir, summary = TRUE ) {
	
	    details <- dir_details(dir)

	if(length(details$doneCalFiles) == 0) stop("No digitised files to import!")

	    metaDig <- load_metaDigitise(details$doneCalFiles, details$name)
	 plot_types <- lapply(metaDig, function(x) x$plot_type)

	if(summary == TRUE){
	
		import <- do.call(rbind,lapply(metaDig, function(x) summary(x)))
	
	} else{
		tmp <- lapply(metaDig, function(x) x$processed_data)
 names(tmp) <- do.call(rbind, lapply(metaDig, function(x) filename(x$image_file)))
 	 import <- order_lists(tmp, plot_types = plot_types)
	}

	return(import)
}

#' @title load_metaDigitise
#' @description Loads metaDigitise calibration files from a directory that is partially or fully digitised already
#' @param doneCalFiles The calibration files that have already been finished taken from directory details
#' @param names The names of the done calibration files
#' @return Returns a list of metaDigitised objects that have already been completed

load_metaDigitise <- function(doneCalFiles, names){
	metaDig <- lapply(doneCalFiles, function(x) readRDS(x))
	names(metaDig) <- names
	return(metaDig)
}

#' @title order_lists
#' @description Will re-order the processed data such that similar types of data are organised into a single list defined by their 
#' @param list The calibration files that have already been finished
#' @param plot_types The list of plot types 
#' @return Returns a list ordered by the plot type

order_lists <- function(list, plot_types){

	mean_error <- list[which(unlist(plot_types) == "mean_error")]
   scatterplot <- list[which(unlist(plot_types) == "scatterplot")]
	   boxplot <- list[which(unlist(plot_types) == "boxplot")]
	      hist <- list[which(unlist(plot_types) == "histogram")]

	dat_list <- purrr::compact(list(mean_error = mean_error, boxplot=boxplot, hist=hist, scatterplot=scatterplot))

return(dat_list)

}
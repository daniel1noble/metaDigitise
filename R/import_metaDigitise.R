#' @title import_metaDigitise
#' @description Imports metaDigitise calibration files from a directory that is partially or fully digitised already
#' @param dir The directory where figures have already been digitised
#' @param summary Logical indicating whether the imported data should be returned in summarised form ('TRUE') or not ('FALSE')
#' @return Returns a list (summary = FALSE) or data frame (summary = TRUE)
#' @export

import_metaDigitise <- function(dir, summary = TRUE ) {
	
	    details <- dir_details(dir)
	    metaDig <- load_metaDigitise(details$doneCalFiles)
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
#' @return Returns a list of metaDigitised objects that have already been completed

load_metaDigitise <- function(doneCalFiles){
	metaDig <- lapply(doneCalFiles, function(x) readRDS(x))
	return(metaDig)
}

#' @title order_lists
#' @description Will re-order the processed data such that similar types of data are organised into a single list defined by their 
#' @param list The calibration files that have already been finished
#' @param plot_types The list of plot types 
#' @return Returns a list ordered by the plot type

order_lists <- function(list, plot_types){

	mean_error <- import[match("mean_error", unlist(plot_types), nomatch = TRUE)]
   scatterplot <- import[match("scatterplot", unlist(plot_types),  nomatch = FALSE)]
	   boxplot <- import[match("boxplot", unlist(plot_types),  nomatch = FALSE)]
	      hist <- import[match("histogram", unlist(plot_types),  nomatch = FALSE)]

	dat_list <- as.list(c(mean_error = mean_error, boxplot=boxplot, hist=hist, scatterplot=scatterplot))

return(dat_list)

}
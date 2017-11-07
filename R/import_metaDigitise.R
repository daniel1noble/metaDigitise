#' @title import_metaDigitise
#' @description Imports metaDigitise calibration files from a directory that is partially or fully digitised already
#' @param dir The directory where figures have already been digitised
#' @param summary Logical indicating whether the imported data should be returned in 
#' @return Returns a list (summary = FALSE) or data frame (summary = TRUE)

import_menu<-function(dir, summary){
	caldat <- dir_details(dir)
	filepaths <- caldat$doneCalFiles
	files <- caldat$calibrations

	if(length(filepaths) == 0) stop("No digitised files to import!", call. = FALSE)

	cat("Import all extracted data or from one image:\n")
	Q <- menu(c("All","One"))

# all 
	if(Q==1) return(import_metaDigitise(dir=dir, summary = summary))

# one
	if(Q==2){
		cat("\n\n")
		cat_matrix(files, 3)
		import_file <- user_options("\nSelect number of file to import ", 1:length(files))
		object <- readRDS(filepaths[as.numeric(import_file)])
		if(summary){
			return(summary(object))
		}else{
			return(object$processed_data)
		}
	}
}


#' @title import_metaDigitise
#' @description Imports metaDigitise calibration files from a directory that is partially or fully digitised already
#' @param dir The directory where figures have already been digitised
#' @param summary Logical indicating whether the imported data should be returned in summarised form ('TRUE') or not ('FALSE')
#' @return Returns a list (summary = FALSE) or data frame (summary = TRUE)
#' @author Daniel Noble - daniel.wa.noble@gmail.com
#' @export

import_metaDigitise <- function(dir, summary = TRUE ) {
	
	    details <- dir_details(dir)

	if(length(details$doneCalFiles) == 0) stop("No digitised files to import!", call. = FALSE)

	    metaDig <- load_metaDigitise(details$doneCalFiles, details$calibrations)
	 plot_types <- lapply(metaDig, function(x) x$plot_type)

	if(summary == TRUE){
	
		import <- do.call(rbind,lapply(metaDig, function(x) summary(x)))
		rownames(import) <- 1:nrow(import)
	
	} else{
		tmp <- lapply(metaDig, function(x) x$processed_data)
 names(tmp) <- do.call(rbind, lapply(metaDig, function(x) filename(x$image_file)))
 	 import <- order_lists(tmp, plot_types = plot_types)
	}

	return(import)
}

#' @title load_metaDigitise
#' @description Loads metaDigitise calibration / data files from a directory containing a set of figures that are partially or fully digitised already.
#' @param doneCalFiles The metaDigitise objects that have already been completed in the directory
#' @param names The names of the finished metaDigitise objects
#' @return Returns a list of metaDigitised objects that have already been completed
#' @author Daniel Noble - daniel.wa.noble@gmail.com

load_metaDigitise <- function(doneCalFiles, names){
	metaDig <- lapply(doneCalFiles, function(x) readRDS(x))
	names(metaDig) <- names
	return(metaDig)
}

#' @title order_lists
#' @description Will re-order the processed data such that similar types of data are organised into a single list defined by their plot type.
#' @param list The list of metaDigitise objects that have already been finished within the caldat/ folder
#' @param plot_types The list of plot types extracted from metaDigitised objects
#' @return Returns a list ordered by the plot type
#' @author Daniel Noble - daniel.wa.noble@gmail.com

order_lists <- function(list, plot_types){

	mean_error <- list[which(unlist(plot_types) == "mean_error")]
   scatterplot <- list[which(unlist(plot_types) == "scatterplot")]
	   boxplot <- list[which(unlist(plot_types) == "boxplot")]
	      hist <- list[which(unlist(plot_types) == "histogram")]

	dat_list <- purrr::compact(list(mean_error = mean_error, boxplot=boxplot, hist=hist, scatterplot=scatterplot))

return(dat_list)

}
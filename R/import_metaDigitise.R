#' @title getExtracted
#' @description Extracts data from a directory that has been previously digitised using metaDigitise()
#' @param dir The directory where figures have already been digitised. There
#' @param summary Logical indicating whether summarised (default) or calibrated data should be returned. 
#' @return Returns a data frame (summary = TRUE) or a list with slots for each plot type (summary = FALSE)
#' @examples
#' \donttest{
#' # Make some mock metaDigitise object
#' 	mock_metaDig <- list(
#' 			image_file = "./image.png",
#' 			flip=FALSE,
#' 			rotate=0,
#' 			plot_type="mean_error",
#' 			variable="y",
#' 			calpoints = data.frame(x=c(0,0),y=c(0,100)), 
#' 			point_vals = c(1,2), 
#' 			entered_N=TRUE,
#' 			raw_data = data.frame(id=rep("control",2), 
#' 						x=c(60,60), 
#' 						y=c(75,50), 
#' 						n=rep(20,2)),
#' 						knownN = NULL,
#' 						error_type="sd",
#' 					processed_data=data.frame(
#' 						id=as.factor("control"),
#' 						mean=1.5, 
#' 						error=0.25, 
#' 						n=20, 	
#' 						variable="y", 
#' 						stringsAsFactors = FALSE)	
#' 					)
#' class(mock_metaDig) <- 'metaDigitise'
#' 
#' # write image file to tmpdir()
#' 		dir <- tempdir()
#' 
#' # Setup directory as it would be if digitised images existed		
#' 		setup_calibration_dir(dir)
#' 
#' # Save the digitised data
#' 		saveRDS(mock_metaDig, file = paste0(dir, "/caldat/", "image"))
#' 
#' #metaDigitise figures
#' data <- getExtracted(dir)
#' }
#' @export

getExtracted <- function(dir, summary=TRUE){

	if(substring(dir, nchar(dir)) != "/") dir <- paste0(dir, "/")

	if(length(dir_details(dir)$doneCalFiles) == 0) stop("No digitised files to import!", call. = FALSE)

	import <- import_metaDigitise(dir=dir, summary=summary)
	
	return(import)
}



#' @title import_menu
#' @description Imports metaDigitise() calibration files from a directory that is partially or fully digitised already
#' @param dir The directory where figures have already been digitised
#' @param summary Logical indicating whether the imported data should be returned in summarised or processed form.
#' @return Returns a list (summary = FALSE) or data frame (summary = TRUE)

import_menu <- function(dir, summary){

	caldat <- dir_details(dir)
	filepaths <- caldat$doneCalFiles
	files <- caldat$calibrations

	if(length(filepaths) == 0) stop("No digitised files to import!", call. = FALSE)

	cat("\nImport all extracted data or from one image:\n")
	Q <- utils::menu(c("All","One"))

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
#' @description Imports metaDigitise() calibration files from a directory that is partially or fully digitised already
#' @param dir The directory where figures have already been digitised
#' @param summary Logical indicating whether the imported data should be returned in summarised form ('TRUE') or not ('FALSE')
#' @return Returns a list (summary = FALSE) or data frame (summary = TRUE)
#' @author Daniel Noble - daniel.wa.noble@gmail.com

import_metaDigitise <- function(dir, summary) {
	
	# Obtain directory details
	    details <- dir_details(dir)

	# Check caldat folder for RDS file of completed figures. If have, load metaDigitise objects, if not, STOP and tell user there are no files to import.
	if(length(details$doneCalFiles) == 0) stop("No digitised files to import!", call. = FALSE)

	    metaDig <- load_metaDigitise(details$doneCalFiles, details$calibrations)
	 plot_types <- lapply(metaDig, function(x) x$plot_type)

	# Using metaDigitise objects build the summary statistics for each digitised file, or extract the raw data and create a list, depending on the summary argument.
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
#' @title import_metaDigitise
#' @description Imports metaDigitise calibration files from a directory that is partially or fully digitised already
#' @param dir The directory where figures have already been digitised
#' @param summary Logical indicating whether the imported data should be returned in summarised form ('TRUE') or not ('FALSE')
#' @return Returns a list if types = 'diff' or a dataframe of raw data or summarise data if types = 'same' or summary = TRUE
#' @export
dir = "./example_figs/scatterplot/"
import_metaDigitise <- function(dir, summary = TRUE){
	
	details <- dir_details(dir)

	    import <- lapply(details$doneCalFiles, function(x) readRDS(x))
	plot_types <- length(unique(lapply(import, function(x) x$plot_type)))

	if(summary == TRUE){
		import <- do.call(rbind,lapply(import, function(x) summary(x)))
	} else{
		if(plot_types > 1){
			import <- lapply(import, function(x) x$processed_data)
			names(import) <- do.call(rbind, lapply(import, function(x) filename(x$image_file)))
		} else {
			import <- do.call(rbind, lapply(import, function(x) x$processed_data))
		}
	}

	return(import)
}


test <- import_metaDigitise(dir, summary = FALSE)

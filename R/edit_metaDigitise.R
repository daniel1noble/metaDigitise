#' @title bulk_edit
#' @description Function for bulk editing previous data extraction through `metaDigitise`
#' @param dir parent directory
#' @param summary logical; whether summary is returned
#' @param cex relative size of text and points in replotting
#' @author Joel Pick

bulk_edit <- function(dir, summary=TRUE, cex){
#list caldat_files
	caldat <- dir_details(dir)
	filepaths <- caldat$doneCalFiles
	files <- caldat$calibrations

	if(length(filepaths)==0) stop("No files to edit", call.=FALSE)

	cat("\nChoose how you want to edit files:\n")
	Q <- utils::menu(c("Cycle through images","Choose specific file to edit","Enter previously omitted sample sizes"))

# cycle 
	if(Q==1){
		for(i in filepaths){
			object <- readRDS(i)
			object$image_file <- paste0(dir,filename(object$image_file))
			object$cex <- cex
			plot.metaDigitise(object)
			editQ <- user_options("\nEdit file? y/n ", c("y","n"))
			if(editQ == "y") {
				object <- edit_metaDigitise(object)
				saveRDS(object, file=i)
			}
		}
	cat("\n**** Reached end of files ****\n\n\n")
	}

# list files
	if(Q==2){
		editQ<-"y"
		while(editQ !="n"){
			cat("\n\n")
			cat_matrix(files, 3)
			edit_file <- user_options("\nSelect number of file to edit ", 1:length(files))
			object <- readRDS(filepaths[as.numeric(edit_file)])
			object$image_file <- paste0(dir,filename(object$image_file))
			object$cex <- cex
			object <- edit_metaDigitise(object)
			saveRDS(object, file=filepaths[as.numeric(edit_file)])
			editQ <- readline("\nEdit more files? y/n ")
		}
	}

# enter_N
	if(Q==3){
		needed <- N_needed(filepaths)
		if(sum(needed)==0) {
			cat("\n**** No files need N ****\n\n\n")
		}else{
			N_files <- filepaths[needed]
			for(i in N_files){
				object <- readRDS(i)
				object$image_file <- paste0(dir,filename(object$image_file))
				object$cex <- cex
				plot.metaDigitise(object)
				object$raw_data <- enter_N(object$raw_data)
				object$entered_N <- TRUE
				object$processed_data <- process_data(object)
				saveRDS(object, file=i)
			}
		}
	}

## finish by importing data 
	import_metaDigitise(dir=dir, summary=summary)
}



N_needed <- function(filepaths){
	metaDig <- load_metaDigitise(filepaths, filename(filepaths))
	no_N <- !sapply(metaDig, function(x) x$entered_N)
	return(no_N)
}


#' @title enter_N
#' @description Enter sample sizes for a group
#' @param raw_data raw_data
#' @param ... Pass additional arguments
#' @author Joel Pick

enter_N <- function(raw_data,...){
	ids <- 	unique(raw_data$id)
	for (i in ids){
		raw_data[raw_data$id==i,"n"] <- user_count(paste("\nGroup \"", i,"\": Enter sample size "))
	}
	return(raw_data)
}


#' @title edit_metaDigitise
#' @description Function for editing previous data extraction through `metaDigitise`
#' @param object an R object of class ‘metaDigitise’
#' @return Data.frame
#' @author Joel Pick

edit_metaDigitise <- function(object){
	plot.metaDigitise(object)

	## ROTATION
	rotQ <- user_options("\nEdit rotation? If yes, then the whole extraction will be redone (y/n) ", c("y","n"))
	if(rotQ=="y") output <- internal_digitise(object$image_file)


	### plot type
	ptQ <- user_options("\nChange plot type? If yes, then the whole extraction will be redone (y/n) ", c("y","n"))
	if(ptQ=="y") output <- internal_digitise(object$image_file)
	

	### variables
	if(object$plot_type=="scatterplot"){
		cat("\ny variable entered as:", object$variable["y"],"\nx variable entered as:", object$variable["x"])
	}else{
		cat("\nVariable entered as:", object$variable)
	}

	varQ <- user_options("\nRename Variables (y/n) ", c("y","n")) 
	if(varQ=="y") {
		object$variable <- ask_variable(object$plot_type)
		plot.metaDigitise(object)
	}
	
	### calibration
	calQ <- user_options("\nEdit calibration? (y/n) ", c("y","n"))
	if(calQ =="y"){
		cal <- user_calibrate(object)
		object$calpoints <- cal$calpoints
		object$point_vals <- cal$point_vals
		plot.metaDigitise(object)
	}
		
	### Extract data
	extractQ <- user_options("\nRe-extract data (y/n) ", c("y","n")) 
	if(extractQ=="y") {
		object$raw_data <- point_extraction(object, edit=TRUE)	
	}
	
	### re-process data
	object$processed_data <- process_data(object)

	## known N
	if(object$plot_type %in% c("scatterplot","histogram")) object$knownN <- do.call(knownN,object)

	## error type
	if(object$plot_type %in% c("mean_error")) {
		cat("\nType of error:", object$error_type)
		errorQ <- user_options("\nRe-enter error type (y/n) ", c("y","n")) 
		if(errorQ=="y") {
			object$error_type <- user_options("Type of error (se, CI95, sd): ", c("se","CI95","sd"))
		}
	}

	class(object) <- 'metaDigitise'
	return(object)


}



#' @title bulk_edit
#' @description Function for bulk editing previous data extraction through `metaDigitise`
#' @param dir parent directory
#' @param summary logical; whether summary is returned
#' @author Joel Pick

bulk_edit <- function(dir, summary=TRUE){
	cat("Choose how you want to edit files:\n")
	Q <- menu(c("Cycle through images","Choose specific file to edit","Enter previously omitted sample sizes"))

	#list caldat_files
	caldat <- dir_details(dir)
	filepaths <- caldat$doneCalFiles
	files <- caldat$calibrations

# cycle 
	if(Q==1){
		for(i in filepaths){
			object <- readRDS(i)
			plot(object)
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
		while(editQ =="y"){
			cat("\n\n")
			cat_matrix(files, 3)
			edit_file <- user_options("\nSelect number of file to edit ", 1:length(files))
			object <- readRDS(filepaths[as.numeric(edit_file)])
			object <- edit_metaDigitise(object)
			saveRDS(object, file=filepaths[edit_file])
			editQ <- user_options("\nEdit more file? y/n ", c("y","n"))
		}
	}

# enter_N
	if(Q==3){
		cat("In progress!!")
	}

## finish by importing data 
	import_metaDigitise(dir=dir, summary=summary)
}

#dir="~/Dropbox/0_postdoc/8_PR repeat/shared/extracted graphs/"

#bulk_edit("~/Dropbox/0_postdoc/8_PR repeat/shared/extracted graphs/",summary=TRUE)




#' @title edit_metaDigitise
#' @description Function for editing previous data extraction through `metaDigitise`
#' @param object an R object of class ‘metaDigitise’
#' @return Data.frame
#' @author Joel Pick
#' @export

edit_metaDigitise <- function(object){
	plot(object)

	## ROTATION
	rotQ <- user_options("Edit rotation? If yes, then the whole extraction will be redone (y/n) ", c("y","n"))
	if(rotQ=="y") output <- metaDigitise(object$image_file)


	### plot type
	ptQ <- user_options("\nChange plot type? If yes, then the whole extraction will be redone (y/n) ", c("y","n"))
	if(ptQ=="y") output <- metaDigitise(object$image_file)
	

	### variables
	if(object$plot_type=="scatterplot"){
		cat("\ny variable entered as:", object$variable["y"],"\nx variable entered as:", object$variable["x"])
	}else{
		cat("\nVariable entered as:", object$variable)
	}

	varQ <- user_options("\nRename Variables (y/n) ", c("y","n")) 
	if(varQ=="y") {
		object$variable <- ask_variable(object$plot_type)
		plot(object)
	}
	

	### calibration
	calQ <- user_options("\nEdit calibration? (y/n) ", c("y","n"))
	if(calQ =="y"){
		cal <- user_calibrate(object)
		object$calpoints <- cal$calpoints
		object$point_vals <- cal$point_vals
		plot(object)
	}

	# ### Number of groups
	# if(object$plot_type != "histogram"){
	# 	cat("\nNumber of Groups:", object$nGroups)
	# 	groupQ <- user_options("\nEdit number of groups (y/n) ", c("y","n")) 
	# if(groupQ=="y") {

	# 	object$nGroups <- user_count("\nNumber of groups: ")
	# 	}
	# }
	
	### N entered? - how to do entering of sample size (also generally mean_error/boxplots)
	# if(plot_type %in% c("mean_error","boxplot")) {
	# 	askN <- user_options("\nEnter sample sizes? y/n ",c("y","n"))
	# 	output$entered_N <- ifelse(askN =="y", TRUE, FALSE)
	# }else{
	# 	output$entered_N <- TRUE
	# }
		
	### Extract data
	extractQ <- user_options("\nRe-extract data (y/n) ", c("y","n")) 
	if(extractQ=="y") {
		object$raw_data <- point_extraction(object, edit=TRUE)	
	}
	
	## error type
	if(object$plot_type %in% c("mean_error")) {
		cat("\nType of error:", object$error_type)
		errorQ <- user_options("\nRe-enter error type (y/n) ", c("y","n")) 
		if(errorQ=="y") {
			object$error_type <- user_options("Type of error (se, CI95, sd): ", c("se","CI95","sd"))
		}
	}

	### re-process data
	object$processed_data <- process_data(object)

	class(object) <- 'metaDigitise'
	return(object)


}


enter_N <- function(raw_data,...){
	ids <- 	unique(raw_data$id)
	for (i in ids){
		raw_data[raw_data$id==i,"n"] <- user_count(paste("Group \"", i,"\": Enter sample size "))
	}
	return(raw_data)
}


bulk_enter_N <- function(){
	## find files that have no entered N

}


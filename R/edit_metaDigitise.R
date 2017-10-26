
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
	ptQ <- user_options("Change plot type? If yes, then the whole extraction will be redone (y/n) ", c("y","n"))
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
	calQ <- user_options("Edit calibration? (y/n) ", c("y","n"))
	if(calQ =="y"){
		cal <- user_calibrate(image, object$image_file)
		object$calpoints <- cal$calpoints
		object$point_vals <- cal$point_vals
		plot(object)
	}

	### Number of groups
	if(plot_type != "histogram"){
		cat("\nNumber of Groups:", object$nGroups)
		groupQ <- user_options("\nRe-enter number of groups (y/n) ", c("y","n")) 
	if(groupQ=="y") {
		output$nGroups <- user_count("\nNumber of groups: ")
		}
	}
	
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
		output$raw_data <- point_extraction(output, edit=TRUE)	
	}
	
	## error type
	if(plot_type %in% c("mean_error")) {
		cat("\nType of error:", object$error_type)
		errorQ <- user_options("\nRe-enter error type (y/n) ", c("y","n")) 
		if(errorQ=="y") {
			output$error_type <- user_options("Type of error (se, CI95, sd): ", c("se","CI95","sd"))
		}
	}

	### re-process data
	output$processed_data <- process_data(output)

	class(output) <- 'metaDigitise'
	return(output)


}
# -function to edit (edit.metaDigitise)
# -- redraws, then can select what you want to change?
# -- prompts
# --- edit axis points
# ---- function recalibrate
# --- edit axis values
# --- edit group names
# --- EDIT N
# --- edit clicked points


#' @title summary.metaDigitise
#' @description Summary method for class ‘metaDigitise’
#' @param object an R object of class ‘metaDigitise’
#' @return Data.frame
#' @author Joel Pick
#' @export

edit_metaDigitise <- function(object){
	plot(object)

	## ROTATION
	rotQ <- user_options("Edit rotation? If yes, then the whole extraction will be redone (y/n) ", c("y","n"))
	if(rotQ=="y") output <- metaDigitise(object$image_file)

	### variables
	if(object$plot_type=="scatterplot"){
		cat("\nx variable entered as:", object$variable["x"],"\ny variable entered as:", object$variable["x"])
	}else{
		cat("\nVariable entered as:", object$variable)
	}
	varQ <- user_options("\nRename Variables (y/n) ", c("y","n")) 
	if(varQ=="y") object$variable <- ask_variable(object$plot_type)


	### calibration
	calQ <- user_options("Edit calibration? (y/n) ", c("y","n"))
	if(calQ =="y"){
		### need to work out plotting here
		cal <- user_calibrate(image, object$image_file)
		object$calpoints <- cal$calpoints
		object$point_vals <- cal$point_vals
	}

	### point reclicking


	### at the end re-process data


}
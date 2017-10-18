
#' @title metaDigitise
#' @description Extracts points from a figure and generate summary statistics
#' @param file Image file
#' @param summary_stats Whether further summary statistics are derived from "mean_se" and "boxplot". Require use to input sample sizes. Currently defunct
#' @return Dataframe
#' @author Joel Pick
#' @export
metaDigitise <- function(file, summary_stats=FALSE){
	
	image <- magick::image_read(file)

	new_image <- graph_rotate(image)
	flush.console()

	output <- list()

	output$plot_type <- plot_type <- specify_type()
	output$calpoints <- calpoints <- cal_coords()	
	output$point_vals <- point_vals <- getVals() 
	
	output$nGroups <- nGroups <- as.numeric(readline("Number of groups: "))

	if(plot_type %in% c("mean_error","boxplot")){
		output$raw_data <- raw_data <- groups_extract(plot_type=plot_type, nGroups=nGroups)	
		cal_data <- calibrate(raw_data=raw_data,calpoints=calpoints, point_vals=point_vals)
		output$group_data <- group_data <- convert_group_data(cal_data=cal_data, plot_type=plot_type, nGroups=nGroups)
	}
	
	
	if(plot_type == "scatterplot"){
		output$raw_data <- raw_data <- group_scatter_extract(nGroups)
		output$group_data <- group_data <- calibrate(raw_data=raw_data,calpoints=calpoints, point_vals=point_vals)
	}	
#	class(output) <- 'metaDigitise_data'
	return(output)
}

# print.metaDigitise_data <- function(x){
# 	cat(paste("Data extracted from:", file))
# 	## if rotated cat("Figure rotated x degrees")
# 	cat(paste("Figure identified as a", plot_type, "with", nGroups, "groups"))
# }


#' @title metaDigitise
#' @description Extracts points from a figure and generate summary statistics
#' @param file Image file
#' @param plot_type Type of plot from "mean_error","boxplot","scatterplot" or"histogram". Function will prompt if not entered by user.
#' @param summary_stats Whether further summary statistics are derived from "mean_se" and "boxplot". Require user to input sample sizes. Currently defunct
#' @return List of 
#' @author Joel Pick
#' @export
metaDigitise <- function(file, plot_type=NULL, summary_stats=FALSE){
	
	image <- magick::image_read(file)

	new_image <- graph_rotate(image)
	flush.console()

	image_width <- image_info(new_image)["width"]
	image_height <- image_info(new_image)["height"]

	output <- list()

	output$plot_type <- plot_type <- if(is.null(plot_type)){specify_type()}else{plot_type}
	stopifnot(plot_type %in% c("mean_error","boxplot","scatterplot","histogram"))

	output$calpoints <- calpoints <- cal_coords()	
	output$point_vals <- point_vals <- getVals() 
	
	output$nGroups <- nGroups <- as.numeric(readline("Number of groups: "))

	if(plot_type %in% c("mean_error","boxplot")){
		output$raw_data <- raw_data <- groups_extract(plot_type=plot_type, nGroups=nGroups, image_width=image_width)	
		cal_data <- calibrate(raw_data=raw_data,calpoints=calpoints, point_vals=point_vals)
		output$group_data <- group_data <- convert_group_data(cal_data=cal_data, plot_type=plot_type, nGroups=nGroups)
	}
	
	if(plot_type == "scatterplot"){
		output$raw_data <- raw_data <- group_scatter_extract(nGroups)
		output$group_data <- group_data <- calibrate(raw_data=raw_data,calpoints=calpoints, point_vals=point_vals)
	}	

	if(plot_type == "histogram"){
		output$raw_data <- histogram_extract()
		cal_data <- calibrate(raw_data=raw_data,calpoints=calpoints, point_vals=point_vals)
		output$grouo_data <- convert_histogram_data(cal_data=cal_data)
	}

#	class(output) <- 'metaDigitise_data'
	return(output)
}

# print.metaDigitise_data <- function(x){
# 	cat(paste("Data extracted from:", file))
# 	## if rotated cat("Figure rotated x degrees")
# 	cat(paste("Figure identified as a", plot_type, "with", nGroups, "groups"))
# }

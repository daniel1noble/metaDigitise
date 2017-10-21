
#' @title metaDigitise
#' @description Extracts points from a figure and generate summary statistics
#' @param image_file Image file
#' @param plot_type Type of plot from "mean_error","boxplot","scatterplot" or"histogram". Function will prompt if not entered by user.
#' @param summary_stats Whether further summary statistics are derived from "mean_se" and "boxplot". Require user to input sample sizes. Currently defunct
#' @return List of 
#' @author Joel Pick
#' @export
metaDigitise <- function(image_file, plot_type=NULL, summary_stats=FALSE){
	
	op <- par(mar=c(0,0,0,0))

	output <- list()
	output$image_file <- image_file

	image <- magick::image_read(image_file)
	rotate_image <- user_rotate_graph(image)
	new_image <- rotate_image$image
	output$flip <- rotate_image$flip
	output$rotate <- rotate_image$rotate

	flush.console()

	image_width <- magick::image_info(new_image)["width"][[1]]
	image_height <- magick::image_info(new_image)["height"][[1]]

	output$plot_type <- plot_type <- if(is.null(plot_type)){specify_type()}else{plot_type}
	stopifnot(plot_type %in% c("mean_error","boxplot","scatterplot","histogram"))

	output$calpoints <- calpoints <- cal_coords()	
	output$point_vals <- point_vals <- getVals(calpoints=calpoints, image_width=image_width, image_height=image_height) 

	if(plot_type != "histogram"){
		nGroups <- as.numeric(readline("Number of groups: "))
	}
	
	if(plot_type %in% c("mean_error","boxplot")){
		output$raw_data <- raw_data <- groups_extract(plot_type=plot_type, nGroups=nGroups, image=new_image, calpoints=calpoints, point_vals=point_vals)	
		cal_data <- calibrate(raw_data=raw_data,calpoints=calpoints, point_vals=point_vals)
		output$processed_data <- convert_group_data(cal_data=cal_data, plot_type=plot_type, nGroups=nGroups)
	}
	
	if(plot_type == "scatterplot"){
		output$raw_data <- raw_data <- group_scatter_extract(nGroups,image=new_image, calpoints=calpoints, point_vals=point_vals)
		output$processed_data <- calibrate(raw_data=raw_data,calpoints=calpoints, point_vals=point_vals)
	}	

	if(plot_type == "histogram"){
		output$raw_data <- raw_data <- histogram_extract(image=new_image, calpoints=calpoints, point_vals=point_vals)
		cal_data <- calibrate(raw_data=raw_data,calpoints=calpoints, point_vals=point_vals)
		output$processed_data <- convert_histogram_data(cal_data=cal_data)
	}

#	class(output) <- 'metaDigitise_data'
	par(op)
	return(output)
}

# print.metaDigitise_data <- function(x){
# 	cat(paste("Data extracted from:", file))
# 	## if rotated cat("Figure rotated x degrees")
# 	cat(paste("Figure identified as a", plot_type, "with", nGroups, "groups"))
# }


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

	if(plot_type %in% c("mean_se","boxplot")){
		output$raw_data <- raw_data <- groups_extract(plot_type=plot_type, nGroups=nGroups)	
		cal_data <- calibrate(raw_data=raw_data,calpoints=calpoints, point_vals=point_vals)
		group_data <- convert_group_data(cal_data=cal_data, plot_type=plot_type, nGroups=nGroups)
	}
	
	
	if(plot_type == "scatterplot"){
		add_removeQ <- "a"
		group_points <- data.frame()
		
		while(add_removeQ!="f"){
			if(add_removeQ=="a"){
						cat(
						    "..............NOW .............",
						    "Click all the data. (Do not hit ESC, close the window or press any mouse key.)",
						    "Once you are done - exit:",
						    " - Windows: right click on the plot area and choose 'Stop'!",
						    " - X11: hit any mouse button other than the left one.",
						    " - quartz/OS X: hit ESC",
						    "If you would like to remove a point, exit, then select remove, \n",
						    "and choose the point. Then choose Add to continue extracting data.",
						    sep = "\n\n"
						  )
				group_points <- rbind(group_points, as.data.frame(locator(type="p", col="red", lwd=2)))}
			if(add_removeQ=="r") {
				cat("Click on point you want to remove")
				remove <- locator(1,type="p", col="green", pch=4, lwd=2)
				x_remove <- which(abs(group_points$x-remove$x) == min(abs(group_points$x-remove$x)))
				y_remove <- which(abs(group_points$y-remove$y) == min(abs(group_points$y-remove$y)))
				## add in a maximum distance to search in; at the moment it searches whole plot area
				if(x_remove==y_remove) {
					points(group_points$x[x_remove],group_points$y[y_remove], col="green", lwd=2)
					group_points <- group_points[-x_remove,]
					}else{cat("Point not identified")
				}
			}
			add_removeQ <- base::readline("Add, remove or finish? a/r/f ")		
		}
	group_data <- digitize::Calibrate(group_points, axis_coords$calpoints, axis_coords$point_vals[1], axis_coords$point_vals[2], axis_coords$point_vals[3], axis_coords$point_vals[4])

	}	
	return(group_data)
}
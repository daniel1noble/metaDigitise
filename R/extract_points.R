
#' @title extract_points
#' @description Extracts points from a figure and generate summary statistics
#' @param file Image file
#' @param plot_type One of "mean_se", "boxplot", or "scatterplot". "mean_se" assumes that there are means and standard error bars, and requires the user to click the upper error bar followed by the mean. "boxplot" assumes that the user will input 5 points, in the order max, upper (75%) quartile, median, lower (25%) quartile, and minimum. "Scatterplot assumes that all points will be clicked"
#' @param summary_stats Whether further summary statistics are derived from "mean_se" and "boxplot". Require use to input sample sizes. Currently defunct
#' @return Dataframe
#' @author Joel Pick
#' @export
extract_points <- function(file, plot_type=c("mean_se","boxplot","scatterplot"), summary_stats=FALSE){
	
	stopifnot(plot_type %in% c("mean_se","boxplot","scatterplot"))

	image <- magick::image_read(file)

	new_image <- graph_rotate(image)
	flush.console()

	axis_coords <- cal_coords()	
	
	if(plot_type %in% c("mean_se","boxplot")){
	
		nMeans <- as.numeric(base::readline("Number of groups: "))
		group_data <- if(plot_type == "mean_se") {as.data.frame(matrix(NA, ncol=4, nrow=nMeans, dimnames=list(NULL, c("id","mean","se","x"))))}else if(plot_type == "boxplot") {as.data.frame(matrix(NA, ncol=7, nrow=nMeans, dimnames=list(NULL, c("id","max","q3","med","q1","min","x"))))}
			
		for(i in 1:nMeans) {
			add_removeQ <- "r"
			while(add_removeQ=="r") {
				group_data[i,1] <- base::readline(paste("Group identifier",i,":"))
				if(plot_type == "mean_se") group_data[i,2:4] <- mean_se_points(axis_coords)
				if(plot_type == "boxplot") group_data[i,2:7] <- boxplot_points(axis_coords)
				add_removeQ <- base::readline("Continue or reclick? c/r ")
				while(!add_removeQ  %in% c("c","r")) add_removeQ <- base::readline("Continue or reclick? c/r ")	
			}
		}
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
				remove <- locator(1,type="p", col="green", pch=4, lwd=2)
				x_remove <- which(abs(group_points$x-remove$x) == min(abs(group_points$x-remove$x)))
				y_remove <- which(abs(group_points$y-remove$y) == min(abs(group_points$y-remove$y)))
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
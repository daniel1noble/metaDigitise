#' @title single_scatter_extract
#' @description Extraction of data from scatterplots
#' @param image image
#' @param calpoints points used for calibration 
#' @param point_vals values for calibration
single_scatter_extract <- function(image, calpoints, point_vals){
	add_removeQ <- "a"
	raw_data <- data.frame()
	while(add_removeQ!="c"){
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
			select_points <- locator(type="p", col="red", lwd=2, pch=19)
			raw_data <- rbind(raw_data, data.frame(x=select_points$x,y=select_points$y))
		}
		if(add_removeQ=="r") {
			cat("Click on points you want to remove\n")
			remove <- identify(raw_data, ,offset=0,labels="*", cex=2, col="green")
			if(length(remove)>0) {
				raw_data <- raw_data[-remove,]
				internal_redraw(image, plot_type="scatterplot", calpoints, point_vals, raw_data)
			}
		}
		add_removeQ <- readline("Add, remove or continue? a/r/c ")		
	}

	return(raw_data)
}


#' @title group_scatter_extract
#' @param nGroups The number of groups
#' @param image image
#' @param calpoints points used for calibration 
#' @param point_vals values for calibration
#' @description Don't know yet Joel.
group_scatter_extract <- function(nGroups,image, calpoints, point_vals){

	raw_data <-data.frame()

 		for(i in 1:nGroups) {
			id <- if(nGroups>1){readline(paste("Group identifier",i,":"))}else{NA}
			group_points <- single_scatter_extract(image, calpoints, point_vals)
			raw_data <- rbind(raw_data, data.frame(id=id, x=group_points$x,y=group_points$y))
		}
	return(raw_data)
}	



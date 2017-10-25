

#' @title add_points
#' @param col point colour
#' @param pch point shape
#' @description Add points to scatterplots
 
add_points <- function(col, pch){
	cat("\nClick on points you want to add\n",
		"If you want to remove a point, or are finished with a group,\n exit (see above), then follow prompts, \n")
	select_points <- locator(type="p", lwd=2, col=col, pch=pch)
	return(as.data.frame(select_points))
}


#' @title remove_points
#' @param raw_data data
#' @description Remove Points from scatterplots
 
remove_points <- function(raw_data){
	cat("\nClick on points you want to remove\n Once you are finished removing points exit (see above)\n")
	remove <- identify(raw_data$x,raw_data$y ,offset=0,labels="*", cex=2, col="green")
	if(length(remove)>0) raw_data <- raw_data[-remove,]
	return(raw_data)
}



#' @title group_scatter_extract
#' @param nGroups The number of groups
#' @param image_file image file name
#' @param calpoints points used for calibration 
#' @param point_vals values for calibration
#' @param ... further arguments passed to or from other methods.
#' @description Extraction of data from scatterplots

group_scatter_extract <- function(nGroups, image_file, calpoints, point_vals,...){

	cat(
    #"..............NOW .............",
    "\nFollow instructions below, to exit point adding or removing:",
    " - Windows: right click on the plot area and choose 'Stop'!",
    " - X11: hit any mouse button other than the left one.",
    " - quartz/OS X: hit ESC\n",
    sep = "\n\n")

	cols <- rep(c("red", "green", "purple"),length.out=nGroups)
	pchs <- rep(rep(c(19, 17, 15),each=3),length.out=nGroups)
	raw_data <- data.frame()

	for(i in 1:nGroups) {
		id <- readline(paste("\nGroup identifier",i,":"))

		add_removeQ <- "a"
		while(add_removeQ!="c"){
			if(add_removeQ=="a"){
				group_points <- add_points(col=cols[i], pch=pchs[i])
				raw_data <- rbind(raw_data, data.frame(id=id, x=group_points$x,y=group_points$y))
			}
			if(add_removeQ=="r") {
				raw_data <- remove_points(raw_data=raw_data)
			}
			internal_redraw(image_file=image_file, plot_type="scatterplot", calpoints=calpoints, point_vals=point_vals,raw_data=raw_data, calibration=TRUE, points=TRUE)
			add_removeQ <- readline("Add, remove or continue? a/r/c ")
		}
	}
	return(raw_data)
}	



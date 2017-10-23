#' @title single_scatter_extract
#' @description Extraction of data from scatterplots
#' @param image image
#' @param image_file image file name
#' @param calpoints points used for calibration 
#' @param point_vals values for calibration
#' @param col point colour
#' @param pch point shape
single_scatter_extract <- function(image, image_file, calpoints, point_vals, col="red",pch=19){
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
			select_points <- locator(type="p", col=col, lwd=2, pch=pch)
			raw_data <- rbind(raw_data, data.frame(x=select_points$x,y=select_points$y))
		}
		if(add_removeQ=="r") {
			cat("Click on points you want to remove\n")
			remove <- identify(raw_data, ,offset=0,labels="*", cex=2, col="green")
			if(length(remove)>0) {
				raw_data <- raw_data[-remove,]
				internal_redraw(image, image_file=image_file, plot_type="scatterplot", calpoints, point_vals, raw_data)
			}
		}
		add_removeQ <- readline("Add, remove or continue? a/r/c ")		
	}

	return(raw_data)
}


#' @title group_scatter_extract
#' @param nGroups The number of groups
#' @param image image
#' @param image_file image file name
#' @param calpoints points used for calibration 
#' @param point_vals values for calibration
#' @description Don't know yet Joel.
group_scatter_extract <- function(nGroups,image, image_file, calpoints, point_vals){

	cols <- rep(c("red", "green", "purple"),length.out=nGroups)
	pchs <- rep(rep(c(19, 17, 15),each=3),length.out=nGroups)
	image_width <- magick::image_info(image)["width"][[1]]
	image_height <- magick::image_info(image)["height"][[1]]
	legend_gap <- image_width/nGroups
	legend_pos <- image_height/40

	raw_data <- data.frame()
	for(i in 1:nGroups) {
		id <- readline(paste("Group identifier",i,":"))
		points(legend_gap/2 + legend_gap*(i-1), -legend_pos*2.5, col=cols[i], pch=pchs[i],xpd=TRUE)
		text(legend_gap/2 + legend_gap*(i-1), -legend_pos, id, col=cols[i],xpd=TRUE)
		group_points <- single_scatter_extract(image, calpoints, point_vals, col=cols[i], pch=pchs[i])
		raw_data <- rbind(raw_data, data.frame(id=id, x=group_points$x,y=group_points$y))
		text(legend_gap/2 + legend_gap*(i-1), -legend_pos*5, paste("n =",nrow(group_points)), col=cols[i],xpd=TRUE)
	}

	return(raw_data)
}	



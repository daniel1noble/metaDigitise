

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
	cat("\nClick on points you want to delete\n Once you are finished removing points exit (see above)\n")
	remove <- identify(raw_data$x,raw_data$y ,offset=0,labels="*", cex=2, col="green")
	if(length(remove)>0) raw_data <- raw_data[-remove,]
	return(raw_data)
}



#' @title group_scatter_extract
#' @param edit logical; whether in edit mode 
#' @param nGroups The number of groups
#' @param raw_data raw data
#' @param ... arguments passed to internal_redraw
#' @description Extraction of data from scatterplots

group_scatter_extract <- function(edit=FALSE, nGroups, raw_data = data.frame(),...){

	cat(
    #"..............NOW .............",
    "\nFollow instructions below, to exit point adding or removing:",
    " - Windows: right click on the plot area and choose 'Stop'!",
    " - X11: hit any mouse button other than the left one.",
    " - quartz/OS X: hit ESC\n",
    sep = "\n\n")

	cols <- rep(c("red", "green", "purple"),length.out=nGroups)
	pchs <- rep(rep(c(19, 17, 15),each=3),length.out=nGroups)

	for(i in 1:nGroups) {
		if(edit){
			ids <- unique(raw_data$id)
			cat("\nGroup identifier",i,":",ids[i],"\n")
			id <- ids[i]
#			editQ <- user_options("Change group identifier? (y/n) ",c("y","n"))
		}else{
			id <- readline(paste("\nGroup identifier",i,":"))
		}
		
		add_removeQ <-  if(edit){ "b" }else{ "a" }
		
		while(add_removeQ!="c"){
			if(add_removeQ=="a"){
				group_points <- add_points(col=cols[i], pch=pchs[i])
				raw_data <- rbind(raw_data, data.frame(id=id, x=group_points$x,y=group_points$y))
			}
			if(add_removeQ=="d") {
				raw_data <- remove_points(raw_data=raw_data)
			}
			internal_redraw(...,raw_data=raw_data, calibration=TRUE, points=TRUE)
			add_removeQ <- readline("\nAdd, delete or continue? a/d/c ")
		}
	}
	return(raw_data)
}	




#' @title delete_points
#' @param raw_data data
#' @description Delete group points to scatterplots
 
delete_group <- function(raw_data){
	ids <- unique(raw_data$id)
	remove <- menu(ids)
	raw_data <- subset(raw_data, id != ids[remove])
	return(raw_data)
}



#' @title edit_group
#' @param raw_data data
#' @param group_id group_id
#' @param ... ...
#' @description Edit group points to scatterplots
 
edit_group <- function(raw_data, group_id,...){
	
	cols <- rep(c("red", "green", "purple"),length.out=90)
	pchs <- rep(rep(c(19, 17, 15),each=3),length.out=90)

	if(is.null(group_id)) {
		group_id <- unique(raw_data$id)[ menu(unique(raw_data$id)) ]
		group_data <- subset(raw_data, id==group_id)
		i <- unique(group_data$group)
		add_removeQ <- "b"
	}else{
		group_data <- data.frame()
		i <- if(nrow(raw_data)==0){ 1 }else{ max(raw_data$group) + 1 }
		add_removeQ <- "a"
	}
	
	raw_data <- subset(raw_data, id != group_id)

	while(add_removeQ!="c"){

		if(add_removeQ=="a"){		
			cat("\nClick on points you want to add.\nIf you want to remove a point, or are finished with a\ngroup, exit (see above), then follow prompts\n")
			select_points <- locator(type="p", lwd=2, col=cols[i], pch=pchs[i])
			group_data <- rbind(group_data, data.frame(id=group_id, x=select_points$x, y=select_points$y, group=i, col=cols[i], pch=pchs[i]) )		
		}

		if(add_removeQ=="d"){
			cat("\nClick on points you want to delete\nOnce you are finished removing points exit (see above)\n")
			remove <- identify(group_data$x,group_data$y ,offset=0,labels="*", cex=2, col="green")
			if(length(remove)>0) 
			group_data <- group_data[-remove,]
		}

		internal_redraw(...,raw_data=rbind(raw_data, group_data), calibration=TRUE, points=TRUE)
		add_removeQ <- readline("\nAdd points, delete points or continue? a/d/c ")
	}

	raw_data <- rbind(raw_data, group_data)		
	return(raw_data)	
}


#' @title group_scatter_extract
#' @param edit logical; whether in edit mode 
#' @param raw_data raw data
#' @param ... arguments passed to internal_redraw
#' @description Extraction of data from scatterplots

#
#	object$raw_data
#	do.call(group_scatter_extract, c(object, edit=TRUE))

group_scatter_extract <- function(edit=FALSE, raw_data = data.frame(), ...){

	cat(
    #"..............NOW .............",
    "\nFollow instructions below, to exit point adding or removing:",
    " - Windows: right click on the plot area and choose 'Stop'!",
    " - X11: hit any mouse button other than the left one.",
    " - quartz/OS X: hit ESC\n",
    sep = "\n\n")


	editQ <- if(edit){ "b" }else{ "a" }

	while(editQ != "f"){
	
		# ids <- unique(raw_data$id)
		group_id <- NULL

		if(editQ=="a"){
			group_id <- user_unique(paste("\nGroup identifier: "), unique(raw_data$id))
			editQ <- "e"
		}

		if(editQ == "e") raw_data <- edit_group(raw_data, group_id,...)
#		if(edit){
#			cat("\nGroup identifier:",ids[i],"\n")
#			idQ <- user_options("Change group identifier? (y/n) ",c("y","n"))

		if(editQ == "d") raw_data <- delete_group(raw_data)
	
		internal_redraw(...,raw_data=raw_data, calibration=TRUE, points=TRUE)
		editQ <- readline("\nAdd group, edit group, delete group, or finish? a/e/d/f ")
	}
	return(raw_data)
}






group_scatter_extract_old <- function(edit=FALSE, nGroups, raw_data = data.frame(),...){

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





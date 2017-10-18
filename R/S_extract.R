#' @title single_scatter_extract
#' @description Extraction of data from scatterplots
single_scatter_extract <- function(){
	add_removeQ <- "a"
	group_points <- data.frame()
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
			select_points <- locator(type="p", col="red", lwd=2)
			group_points <- rbind(group_points, data.frame(id="z",x=select_points$x,y=select_points$y))}
		if(add_removeQ=="r") {
			cat("Click on point you want to remove\n")
			remove <- locator(1,type="p", col="green", pch=4, lwd=2)
			x_remove <- which(abs(group_points$x-remove$x) == min(abs(group_points$x-remove$x)))
			y_remove <- which(abs(group_points$y-remove$y) == min(abs(group_points$y-remove$y)))
			## add in a maximum distance to search in; at the moment it searches whole plot area
			#

			if(length(x_remove)>1 & length(y_remove)>1){
				cat("**** Point not identified ****\n")
			}else if(length(x_remove)>1 & length(y_remove)==1){
				x_remove <- x_remove[x_remove %in% y_remove]
				points(group_points$x[x_remove],group_points$y[y_remove], col="green", lwd=2)
				group_points <- group_points[-x_remove,]
				cat("**** Point successfully removed ****\n")
			}else if(length(y_remove)>1 & length(x_remove)==1){
				y_remove <- y_remove[y_remove %in% x_remove]
				points(group_points$x[x_remove],group_points$y[y_remove], col="green", lwd=2)
				group_points <- group_points[-x_remove,]
				cat("**** Point successfully removed ****\n")
			}else if(x_remove==y_remove) {
				points(group_points$x[x_remove],group_points$y[y_remove], col="green", lwd=2)
				group_points <- group_points[-x_remove,]
				cat("**** Point successfully removed ****\n")	
			}else{cat("**** Point not identified ****\n")
			}
		}
		add_removeQ <- base::readline("Add, remove or continue? a/r/c ")		
	}

	return(group_points)
}


# group_scatter_extract <- function(nGroups){

# 		for(i in 1:nGroups) {
# 		raw_data[rows,1] <- readline(paste("Group identifier",i,":"))

# }	

#' @title histogram_extract
#' @description Extraction of data from histograms
#' @param edit logical; whether in edit mode 
#' @param raw_data raw data
#' @param calpoints The calibration points
#' @param cex point size
#' @param ... arguments to pass to internal_redraw

histogram_extract <- function(edit=FALSE, raw_data = data.frame(), calpoints, cex, ...){

	if(edit){ 
		idQ <- user_options("Change group identifier? (y/n) ",c("y","n"))
		if(idQ=="y"){
			group_id <- readline("\nGroup identifier: \n")
			raw_data$id <- group_id
		}else{group_id<-raw_data$id}
	}else{
		cat("\nIf there are multiple groups, enter unique group identifiers (otherwise press enter)")
		group_id <- readline("\nGroup identifier: \n")
	}


	histQ <- if(edit){ "b" }else{ "a" }
	i <- if(edit){ max(unique(raw_data$bar)) }else{ 0 }
	bar_cols <- c("red","orange")
	box_y <- c(mean(calpoints$y[3:4]), mean(calpoints$y[3:4]),0,0,mean(calpoints$y[3:4]))/2
	box_x <- c(0,mean(calpoints$x[1:2]), mean(calpoints$x[1:2]),0,0)/2


	while(histQ != "f"){
		
		if(histQ=="a"){
			graphics::polygon(box_x,box_y, col="red", border=NA)
			cat("\nClick on the left followed by the right upper corners of each bar\n Double click on red box in bottom left corner to exit extraction\n")
		} 
		while(histQ=="a"){
			i=i+1
			bar_points <- locator_mD(2, line=TRUE, col=bar_cols[is.even(i)+1], pch=19,cex=cex)
			#graphics::locator(2, type="o", col=bar_cols[is.even(i)+1], lwd=2, pch=19)
			if( mean(bar_points$x)<max(box_x) & mean(bar_points$y)<max(box_y) & mean(bar_points$x)>min(box_x) & mean(bar_points$y)>min(box_y)){
					histQ <- "b"
					i=i-1
				}
			if(histQ=="a") raw_data <- rbind(raw_data, data.frame(id=group_id, x=bar_points$x,y=bar_points$y, bar=i))
		}

		if(histQ=="d"){
			delQ <- user_options("\nEnter a bar number to delete (displayed above bars) ", unique(raw_data$bar)) 
			raw_data <- subset(raw_data, raw_data$bar != delQ)
		}

		internal_redraw(raw_data=raw_data, calpoints=calpoints, cex=cex, ...)
		histQ <- readline("Add bar, Delete bar or Finish plot? (a/d/f) \n")

	}
	return(raw_data)
}




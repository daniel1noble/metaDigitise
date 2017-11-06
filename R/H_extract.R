#' @title histogram_extract
#' @param edit logical; whether in edit mode 
#' @param raw_data raw data
#' @param ... arguments to pass to internal_redraw
#' @description Extraction of data from histograms
histogram_extract <- function(edit=FALSE, raw_data = data.frame(), ...){


	if(edit){ 
		idQ <- user_options("Change group identifier? (y/n) ",c("y","n"))
		if(idQ=="y"){
			group_id <- readline("\nGroup identifier: ")
			raw_data$id <- group_id
		}
	}else{
		group_id <- readline("\nGroup identifier: ")
	}


	histQ <- if(edit){ "b" }else{ "a" }
	i <- if(edit){ max(unique(raw_data$bar)) }else{ 0 }

	while(histQ != "f"){
		
		if(histQ=="a"){
			i=i+1
			cat("Click on left then right upper corners of bar\n")
			bar_points <- locator(2, type="o", col="red", lwd=2, pch=19)
			raw_data <- rbind(raw_data, data.frame(id=group_id, x=bar_points$x,y=bar_points$y, bar=i))
		}

		if(histQ=="d"){
			delQ <- user_options("\nEnter a bar number to delete (displayed above bars) ", unique(raw_data$bar)) 
			raw_data <- subset(raw_data, bar != delQ)
		}

		internal_redraw(raw_data=raw_data,...)
		histQ <- readline("Add bar, Delete bar or Finish plot? a/d/f ")

	}
	return(raw_data)
}




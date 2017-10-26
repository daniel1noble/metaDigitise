#' @title histogram_extract
#' @param ... arguments to pass to internal_redraw
#' @description Extraction of data from histograms
histogram_extract <- function(...){

	histQ <- "a"
	i=0
	raw_data <- data.frame()
	while(histQ != "c"){
		
		if(histQ=="a"){
			i=i+1
			cat("Click on left then right upper corners of bar\n")

			bar_points <- locator(2, type="o", col="red", lwd=2, pch=19)
			raw_data <- rbind(raw_data, data.frame(x=bar_points$x,y=bar_points$y, bar=i))
			internal_redraw(raw_data=raw_data,...)
			histQ <- readline("Add, reclick or continue? a/r/c ")
		}

		if(histQ=="r"){
			i=i-1
			remove <- c(nrow(raw_data)-1,nrow(raw_data))
			raw_data <- raw_data[-remove,]
			internal_redraw(raw_data=raw_data,...)
			histQ <- "a"
		}
	}
	return(raw_data)
}




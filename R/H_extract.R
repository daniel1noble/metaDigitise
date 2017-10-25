#' @title histogram_extract
#' @param image_file image file name
#' @param calpoints points used for calibration 
#' @param point_vals values for calibration
#' @param ... further arguments passed to or from other methods.
#' @description Extraction of data from histograms
histogram_extract <- function(image_file, calpoints, point_vals,...){

	histQ <- "a"
	raw_data <- data.frame()
	while(histQ != "c"){
		if(histQ=="a"){
			cat("Click on left then right upper corners of bar\n")

			bar_points <- locator(2, type="o", col="red", lwd=2, pch=19)
			raw_data <- rbind(raw_data, data.frame(x=bar_points$x,y=bar_points$y))
			histQ <- readline("Add, reclick or continue? a/r/c ")
		}

		if(histQ=="r"){
			remove <- c(nrow(raw_data)-1,nrow(raw_data))
			raw_data <- raw_data[-remove,]
			internal_redraw(image_file=image_file, plot_type="histogram", calpoints=calpoints, point_vals=point_vals, raw_data=raw_data)
			histQ <- "a"
		}
	}
	return(raw_data)
}


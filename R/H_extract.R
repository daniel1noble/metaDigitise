#' @title histogram_extract
#' @param image image
#' @param image_file image file name
#' @param calpoints points used for calibration 
#' @param point_vals values for calibration
#' @description Extraction of data from histograms
histogram_extract <- function(image, image_file, calpoints, point_vals){

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
			internal_redraw(image, image_file=image_file, plot_type="histogram", calpoints, point_vals, raw_data)
			histQ <- "a"
		}
	}
	return(raw_data)
}

#' @title convert_histogram_data 
#' @param cal_data The calibration data
#' @description Conversion of extracted data from histogram
convert_histogram_data <- function(cal_data){
	#nBars <- nrow(raw_data)/2
	midpoints <- c()
	freq <- c()
	for(i in seq(2,nrow(cal_data),2)){
		bar_data <- cal_data[c(i-1,i),]
		midpoints <- c(midpoints, mean(bar_data$x))
		freq <- c(freq, round(mean(bar_data$y)))
	}
	return(data.frame(midpoints=midpoints, frequency=freq))
}
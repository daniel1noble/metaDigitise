#' @title histogram_extract
#' @description Extraction of data from histograms
histogram_extract <- function(){

	histQ <- "a"
	raw_data <- data.frame()
	while(histQ != "c"){
		if(histQ=="a"){
			cat("Click on left then right upper corners of bar\n")
			bar_points <- locator(2, type="o", col="red", lwd=2, pch="|")
			raw_data <- rbind(raw_data, data.frame(x=bar_points$x,y=bar_points$y))
			histQ <- readline("Add, reclick or continue? a/r/c ")
			if(histQ=="r") {
				points(bar_points$x,bar_points$y, col="green", lwd=2, pch="|")
				lines(bar_points$x,bar_points$y, col="green", lwd=2)
			}
		}

		if(histQ=="r"){
			remove <- c(nrow(raw_data)-1,nrow(raw_data))
			raw_data <- raw_data[-remove,]
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
	for(i in seq(2,nrow(raw_data),2)){
		bar_data <- raw_data[c(i-1,i),]
		midpoints <- c(midpoints, mean(bar_data$x))
		freq <- c(freq, round(mean(bar_data$y)))
	}
	hist_data <- rep(midpoints, freq)
	return(c(mean=mean(hist_data),sd=sd(hist_data),n=length(hist_data)))
}


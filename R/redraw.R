#' @title internal_redraw
#' @param image image 
#' @param plot_type The type of plot
#' @param calpoints points used for calibration 
#' @param point_vals values for calibration
#' @param raw_data previously extracted data points
#' @description Redraws figure and extraction data
internal_redraw <- function(image, plot_type, calpoints, point_vals, raw_data){
	plot(image)
	image_width <- magick::image_info(image)["width"][[1]]
	image_height <- magick::image_info(image)["height"][[1]]

	points(calpoints, pch=3, col="blue", lwd=2)
	lines(calpoints[1:2,], pch=3, col="blue", lwd=2)
	lines(calpoints[3:4,], pch=3, col="blue", lwd=2)
	text(calpoints$x - c(0, 0, image_width/30, image_width/30), calpoints$y - c(image_height/30, image_height/30, 0, 0), point_vals, col="blue", cex=2)

	if(plot_type %in% c("mean_error","boxplot") & nrow(raw_data)>0){
		for(i in unique(raw_data$id)){
			group_data <- subset(raw_data,id==i)
			points(y~x,group_data, pch=19, col="red")
			if(plot_type %in% c("mean_error", "boxplot")){
				lines(y~x, group_data, lwd=2, col="red")
				text(mean(group_data$x)+image_width/30,mean(group_data$y),group_data$id[1],srt=90, col="Red")
			}
		}
	}

	if(plot_type=="scatterplot"& nrow(raw_data)>0){
		points(y~x,raw_data, pch=19, col="red")
	}


	if(plot_type=="histogram"& nrow(raw_data)>0){
		for(i in seq(2,nrow(raw_data),2)){
			bar_data <- raw_data[c(i-1,i),]
			points(y~x,bar_data, pch=19, col="red")
			lines(y~x, bar_data, lwd=2, col="red")
		}
	}
}



#' @title redraw
#' @param mD_data metaDigitise output 
#' @description Redraws figure and extraction data
#' @author Joel Pick
#' @export
redraw <- function(mD_data){
	image <- magick::image_read(mD_data$image_file)
	new_image <- rotate_graph(image=image, flip=mD_data$flip, rotate=mD_data$rotate)
	internal_redraw(image=new_image, plot_type=mD_data$plot_type, calpoints=mD_data$calpoints, point_vals=mD_data$point_vals, raw_data=mD_data$raw_data)
}
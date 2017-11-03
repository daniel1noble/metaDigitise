#' @title rotate_graph
#' @description Rotates/flips imported figures
#' @param image Image object from magick::image_read
#' @param flip whether to flip figure
#' @param rotate how much to rotate figure

redraw_rotation <- function(image, flip, rotate){
	if(flip) image <- magick::image_flop(magick::image_rotate(image,270))
	image <- magick::image_rotate(image, rotate)
	return(image)
}



#' @title redraw_calibration
#' @param plot_type plot_type
#' @param variable variable
#' @param calpoints The calibration points
#' @param point_vals The point values
#' @param image_details image_details
#' @param scalar amount to scale size points/text/lines according to plot size
#' @description plots calibration data on graph

redraw_calibration <- function(plot_type, variable, calpoints,point_vals,image_details, scalar){
	x_shift <- image_details["width"]/30
	y_shift <- image_details["height"]/30
	text_cex <- 2*scalar
	line_width <- 2*scalar
	cal_col <- "blue"

	points(calpoints, pch=3, col=cal_col, lwd=line_width)

	lines(calpoints[1:2,], col=cal_col, lwd=line_width)
	text(calpoints$x[1:2] - rep(x_shift, 2), calpoints$y[1:2], point_vals[1:2], col=cal_col, cex=text_cex)
	if(plot_type=="histogram"){
		text(mean(calpoints$x[3:4]), mean(calpoints$y[3:4]) - y_shift*1.5, variable[1], col=cal_col, cex=text_cex)
	}else{	
		text(mean(calpoints$x[1:2]) - x_shift*1.5, mean(calpoints$y[1:2]), variable[1], col=cal_col, cex=text_cex, srt=90)
		}

	if(!plot_type %in% c("mean_error","boxplot")){
		lines(calpoints[3:4,], col=cal_col, lwd=line_width)
		text(calpoints$x[3:4], calpoints$y[3:4] - rep(y_shift, 2), point_vals[3:4], col=cal_col, cex=text_cex)
		text(mean(calpoints$x[3:4]), mean(calpoints$y[3:4]) - y_shift*1.5, variable[2], col=cal_col, cex=text_cex)
	}
}



#' @title redraw_points
#' @param plot_type plot_type
#' @param raw_data The raw data
#' @param image_details image_details
#' @param scalar amount to scale size points/text/lines according to plot size
#' @description plots clicked data on graph

redraw_points <- function(plot_type, raw_data, image_details, scalar){
	image_width <- image_details["width"]
	image_height <- image_details["height"]
	legend_pos <- image_height/40

	text_cex <- 1*scalar
	line_width <- 2*scalar
	point_cex <- 1*scalar
	point_col="red"

	## legend
	if(plot_type == "mean_error"){
		points((image_width/4)*c(1,3,3), rep(-legend_pos,3), pch=c(19,19,20), col=c(point_col,point_col,"yellow"), cex=point_cex, xpd=TRUE)
		text((image_width/4)*c(1,3), rep(-legend_pos*2,2), c("mean","error"), cex=text_cex, xpd=TRUE)
	}

	if(plot_type %in% c("mean_error","boxplot") & nrow(raw_data)>0){
		for(i in unique(raw_data$id)){
			group_data <- subset(raw_data,id==i)
			points(y~x,group_data, pch=19, col=point_col, cex=point_cex)
			lines(y~x, group_data, lwd=line_width, col=point_col)
			text(mean(group_data$x)+image_width/30,mean(group_data$y),paste0(group_data$id[1]," (",group_data$n[1],")"),srt=90, cex=text_cex, col=point_col)
			if(plot_type == "mean_error"){
				points(group_data$x[1],group_data$y[1], pch=20, col="yellow", cex=point_cex)
			}
		}
	}

	if(plot_type=="scatterplot"& nrow(raw_data)>0){
		points(y~x,raw_data, pch=raw_data$pch, col=as.character(raw_data$col), cex=point_cex)

	#legend
		legend_dat <- aggregate(x~id+col+pch+group,raw_data, length)
		nGroups <- nrow(legend_dat)
		legend_x <- (image_width/nGroups)/2 + (image_width/nGroups)*((1:nGroups)-1)

		 points(legend_x, rep(-legend_pos*2.5,nGroups), 
		 	col=as.character(legend_dat$col), pch=legend_dat$pch, xpd=TRUE, cex=point_cex)
		 text(legend_x, rep(-legend_pos,nGroups), legend_dat$id, col=as.character(legend_dat$col), cex=text_cex, xpd=TRUE)
		 text(legend_x, rep(-legend_pos*5,nGroups), paste("n =",legend_dat$x), col=as.character(legend_dat$col), cex=text_cex, xpd=TRUE)
	}

	if(plot_type=="histogram"& nrow(raw_data)>0){
		for(i in unique(raw_data$bar)){
			bar_data <- subset(raw_data, bar==i)
			points(y~x,bar_data, pch=19, col=point_col, cex=point_cex)
			lines(y~x, bar_data, lwd=line_width, col=point_col)
			text(mean(bar_data$x),mean(bar_data$y)+legend_pos,bar_data$bar[1], col=point_col, cex=text_cex)
		}
	}
}


#' @title internal_redraw
#' @param image_file Image filename
#' @param flip whether to flip figure
#' @param rotate how much to rotate figure
#' @param plot_type plot_type
#' @param variable variable
#' @param calpoints The calibration points
#' @param point_vals The point values
#' @param raw_data The raw data
#' @param rotation logical, should figure be rotated
#' @param calibration logical, should calibration be redrawn
#' @param points logical, should points be redrawn
#' @param ... further arguments passed to or from other methods.
#' @description Redraws figure and extraction data



#image_file, flip, rotate, image_details, plot_type, calpoints, point_vals, raw_data

internal_redraw <- function(image_file, flip=FALSE, rotate=0, plot_type=NULL, variable=NULL, calpoints=NULL, point_vals=NULL, raw_data=NULL, rotation=TRUE, calibration=TRUE, points=TRUE, ...){

	op <- par(mar=c(3,0,2,0), mfrow=c(1,1))
	on.exit(par(op))

	plot_size <- par("pin")
	scalar <- plot_size[1]/7

	image <- magick::image_read(image_file)
	if(rotation) image <- redraw_rotation(image=image, flip=flip, rotate=rotate)

	image_details <- c(width = magick::image_info(image)["width"][[1]], height = magick::image_info(image)["height"][[1]])

	text_cex <- 1*scalar

	plot(image)
	mtext(filename(image_file),3, 1, cex=text_cex)
	if(!is.null(plot_type)) mtext(plot_type,3, 0, cex=text_cex)

	if(is.null(calpoints)) calibration=FALSE
	if(calibration) redraw_calibration(plot_type=plot_type, variable=variable, calpoints=calpoints,point_vals=point_vals,image_details=image_details, scalar=scalar)

	if(is.null(raw_data)) points=FALSE
	if(points) redraw_points(plot_type=plot_type,raw_data=raw_data,image_details=image_details, scalar=scalar)

}

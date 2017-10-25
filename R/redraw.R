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
#' @description plots calibration data on graph

redraw_calibration <- function(plot_type, variable, calpoints,point_vals,image_details){
	x_shift <- image_details["width"]/30
	y_shift <- image_details["height"]/30
	text_cex <- 2
	cal_col <- "blue"

	points(calpoints, pch=3, col=cal_col, lwd=2)

	lines(calpoints[1:2,], col=cal_col, lwd=2)
	text(calpoints$x[1:2] - rep(x_shift, 2), calpoints$y[1:2], point_vals[1:2], col=cal_col, cex=text_cex)
	text(mean(calpoints$x[1:2]) - x_shift*1.5, mean(calpoints$y[1:2]), variable["y"], col=cal_col, cex=text_cex, srt=90)
	

	if(!plot_type %in% c("mean_error","boxplot")){
		lines(calpoints[3:4,], col=cal_col, lwd=2)
		text(calpoints$x[3:4], calpoints$y[3:4] - rep(y_shift, 2), point_vals[3:4], col=cal_col, cex=text_cex)
		text(mean(calpoints$x[3:4]), mean(calpoints$y[3:4]) - y_shift*1.5, variable["x"], col=cal_col, cex=text_cex)
	}
}



#' @title redraw_points
#' @param plot_type plot_type
#' @param raw_data The raw data
#' @param image_details image_details
#' @description plots clicked data on graph

redraw_points <- function(plot_type,raw_data,image_details){
	image_width <- image_details["width"]
	image_height <- image_details["height"]
	legend_pos <- image_height/40

	## legend
	if(plot_type == "mean_error"){
		points((image_width/4)*c(1,3,3), rep(-legend_pos,3), pch=c(19,19,20), col=c("red","red","yellow"),xpd=TRUE)
		text((image_width/4)*c(1,3), rep(-legend_pos*2,2), c("mean","error"),xpd=TRUE)
	}

	if(plot_type %in% c("mean_error","boxplot") & nrow(raw_data)>0){
		for(i in unique(raw_data$id)){
			group_data <- subset(raw_data,id==i)
			points(y~x,group_data, pch=19, col="red")
			lines(y~x, group_data, lwd=2, col="red")
			text(mean(group_data$x)+image_width/30,mean(group_data$y),paste0(group_data$id[1]," (",group_data$n[1],")"),srt=90, col="Red")
			if(plot_type == "mean_error"){
				points(group_data$x[1],group_data$y[1], pch=20, col="yellow")
			}
		}
	}

	if(plot_type=="scatterplot"& nrow(raw_data)>0){
		group_id <- unique(raw_data$id)
		nGroups <- length(group_id)
		cols <- rep(c("red", "green", "purple"),length.out=nGroups)
		pchs <- rep(rep(c(19, 17, 15),each=3),length.out=nGroups)
		legend_gap <- image_width/nGroups

		for(i in 1:nGroups){
			group_data <- subset(raw_data,id==group_id[i])
			points(y~x,group_data, pch=pchs[i], col=cols[i])
			points(legend_gap/2 + legend_gap*(i-1), -legend_pos*2.5, col=cols[i], pch=pchs[i],xpd=TRUE)
			text(legend_gap/2 + legend_gap*(i-1), -legend_pos, group_id[i], col=cols[i],xpd=TRUE)
			text(legend_gap/2 + legend_gap*(i-1), -legend_pos*5, paste("n =",nrow(group_data)), col=cols[i],xpd=TRUE)
		}		
	}

	if(plot_type=="histogram"& nrow(raw_data)>0){
		for(i in seq(2,nrow(raw_data),2)){
			bar_data <- raw_data[c(i-1,i),]
			points(y~x,bar_data, pch=19, col="red")
			lines(y~x, bar_data, lwd=2, col="red")
		}
	}
}



#' @title internal_redraw
#' @param image_file Image filename
#' @param flip whether to flip figure
#' @param rotate how much to rotate figure
#' @param image_details image_details
#' @param plot_type plot_type
#' @param variable variable
#' @param calpoints The calibration points
#' @param point_vals The point values
#' @param raw_data The raw data
#' @param rotation logical, should figure be rotated
#' @param calibration logical, should calibration be redrawn
#' @param points logical, should points be redrawn
#' @param return_image return_image object
#' @param ... further arguments passed to or from other methods.
#' @description Redraws figure and extraction data

#image_file, flip, rotate, image_details, plot_type, calpoints, point_vals, raw_data

internal_redraw <- function(image_file, flip=FALSE, rotate=0, image_details=NULL, plot_type=NULL, variable=NULL, calpoints=NULL, point_vals=NULL, raw_data=NULL, rotation=TRUE, calibration=TRUE, points=TRUE, return_image=FALSE,...){

	op <- par(mar=c(3,0,2,0))

	image <- magick::image_read(image_file)
	new_image <- redraw_rotation(image=image, flip=flip, rotate=rotate)
	plot(new_image)
	mtext(filename(image_file),3, 1)

	if(!is.null(plot_type)) mtext(plot_type,3, 0)

	if(is.null(calpoints)) calibration=FALSE
	if(calibration) redraw_calibration(plot_type=plot_type, variable=variable, calpoints=calpoints,point_vals=point_vals,image_details=image_details)

	if(is.null(raw_data)) points=FALSE
	if(points) redraw_points(plot_type=plot_type,raw_data=raw_data,image_details=image_details)

	if(return_image) return(new_image)
	on.exit(par(op))
}

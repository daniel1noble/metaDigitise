
#' @title metaDigitise
#' @description Extracts points from a figure and generate summary statistics
#' @param image_file Image file
#' @param plot_type Type of plot from "mean_error","boxplot","scatterplot" or"histogram". Function will prompt if not entered by user.
#' @return List of 
#' @author Joel Pick
#' @export

metaDigitise <- function(image_file, plot_type=NULL){
	
	op <- par(mar=c(3,0,0,0))

	output <- list()
	output$image_file <- image_file

	image <- magick::image_read(image_file)
	rotate_image <- user_rotate_graph(image)
	new_image <- rotate_image$image
	output$flip <- rotate_image$flip
	output$rotate <- rotate_image$rotate

	flush.console()

	image_width <- magick::image_info(new_image)["width"][[1]]
	image_height <- magick::image_info(new_image)["height"][[1]]

	output$plot_type <- plot_type <- if(is.null(plot_type)){specify_type()}else{plot_type}
	stopifnot(plot_type %in% c("mean_error","boxplot","scatterplot","histogram"))

	
	if(plot_type == "scatterplot"){
		x_variable <- readline("What is the x variable? ")
		y_variable <- readline("What is the y variable? ")
	}else{
		variable <- readline("What is the variable? ")
	}

	output$calpoints <- calpoints <- cal_coords()	
	output$point_vals <- point_vals <- getVals(calpoints=calpoints, image_width=image_width, image_height=image_height) 

	is.wholenumber <- function(x, tol = .Machine$double.eps^0.5)  abs(x - round(x)) < tol

	if(plot_type != "histogram"){
		nGroups <- as.numeric(readline("Number of groups: "))
		while(is.na(nGroups)| nGroups<1 | !is.wholenumber(nGroups)){
			nGroups <- as.numeric(readline("**** Number of groups must be an integer above 0 ****\nNumber of groups: "))
		}
	}




	if(plot_type %in% c("mean_error","boxplot")){
		output$raw_data <- raw_data <- groups_extract(plot_type=plot_type, nGroups=nGroups, image=new_image, calpoints=calpoints, point_vals=point_vals)	
		cal_data <- calibrate(raw_data=raw_data,calpoints=calpoints, point_vals=point_vals)
		output$processed_data <- convert_group_data(cal_data=cal_data, plot_type=plot_type, nGroups=nGroups)
#		output$processed_data[,c("mean","error","n")] <- as.numeric(output$processed_data[,c("mean","error","n")])
		output$processed_data$variable <- variable
	}
	
	if(plot_type == "scatterplot"){
		output$raw_data <- raw_data <- group_scatter_extract(nGroups,image=new_image, calpoints=calpoints, point_vals=point_vals)
		output$processed_data <- calibrate(raw_data=raw_data,calpoints=calpoints, point_vals=point_vals)
		output$processed_data$x_variable <- x_variable
		output$processed_data$y_variable <- y_variable
	}	

	if(plot_type == "histogram"){
		output$raw_data <- raw_data <- histogram_extract(image=new_image, calpoints=calpoints, point_vals=point_vals)
		cal_data <- calibrate(raw_data=raw_data,calpoints=calpoints, point_vals=point_vals)
		output$processed_data <- convert_histogram_data(cal_data=cal_data)
		output$processed_data$variable <- variable
	}

	class(output) <- 'metaDigitise'
	on.exit(par(op))
	return(output)
}


#' @title print.metaDigitise
#' @description Print method for class ‘metaDigitise’
#' @param x an R object of class ‘metaDigitise’
#' @param ... further arguments passed to or from other methods.
#' @author Joel Pick
#' @export

print.metaDigitise <- function(x, ...){
	cat(paste("Data extracted from:\n", x$image_file,"\n"))
	cat(paste0("Figure", ifelse(x$flip, " flipped and ", " "), "rotated ", x$rotate, " degrees"),"\n")
	cat(paste("Figure identified as", x$plot_type, "with", length(unique(x$processed_data$id)), "groups","\n"))
}


#' @title summary.metaDigitise
#' @description Summary method for class ‘metaDigitise’
#' @param object an R object of class ‘metaDigitise’
#' @param ... further arguments passed to or from other methods.
#' @return Data.frame
#' @author Joel Pick
#' @export

summary.metaDigitise<-function(object, ...){

	pd <- object$processed_data


	if (object$plot_type == "mean_error"){
		out <- data.frame(filename=object$image_file, group_id=pd$id, variable=pd$variable, mean=pd$mean, sd=se_to_sd(se=pd$error,n=as.numeric(pd$n)), n=pd$n)
	}
	
	if (object$plot_type == "boxplot"){
		out <- data.frame(filename=object$image_file, group_id=pd$id, variable=pd$variable, mean=rqm_to_mean(min=pd$min,LQ=pd$q1,median=pd$med,UQ=pd$q3,max=pd$max), sd=rqm_to_sd(min=pd$min,LQ=pd$q1,UQ=pd$q3,max=pd$max,n=pd$n), n=pd$n)
	}

	if (object$plot_type=="scatterplot"){
		out <- as.data.frame(do.call(rbind, lapply(split(pd,pd$id), function(z){ 
			data.frame(filename=object$image_file, group_id=z$id[1], x_var=z$x_variable[1], x_mean=mean(z$x), x_sd=sd(z$x), y_variable=z$y_var[1], y_mean=mean(z$y), y_sd=sd(z$y), n=nrow(z), r=cor(z$x,z$y))
		})))
	}

	if (object$plot_type=="histogram"){
		hist_data <- rep(pd$midpoints, pd$freq)
		out <- data.frame(filename=object$image_file, group_id=NA, variable=pd$variable[1], mean=mean(hist_data),sd=sd(hist_data),n=length(hist_data))
	}

	return(out)
}




#' @title redraw.metaDigitise
#' @param object an R object of class ‘metaDigitise’ 
#' @description Redraws figure and extraction data
#' @author Joel Pick
#' @export

redraw.metaDigitise <- function(object){
	op <- par(mar=c(3,0,0,0))
	image <- magick::image_read(object$image_file)
	new_image <- rotate_graph(image=image, flip=object$flip, rotate=object$rotate)
	internal_redraw(image=new_image, plot_type=object$plot_type, calpoints=object$calpoints, point_vals=object$point_vals, raw_data=object$raw_data)
	on.exit(par(op))
}


#' @title metaDigitise
#' @description Extracts points from a figure and generate summary statistics
#' @param image_file Image file
#' @param plot_type Type of plot from "mean_error","boxplot","scatterplot" or"histogram". Function will prompt if not entered by user.
#' @return List of 
#' @author Joel Pick
#' @export

metaDigitise <- function(image_file, plot_type=NULL){
	
	op <- par(mar=c(3,0,1,0))
	
	output <- list()
	output$image_file <- image_file

	rotate_image <- user_rotate_graph(image_file)
	image <- rotate_image$image
	output$flip <- rotate_image$flip
	output$rotate <- rotate_image$rotate

	flush.console()

	image_width <- magick::image_info(image)["width"][[1]]
	image_height <- magick::image_info(image)["height"][[1]]

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


	if(plot_type != "histogram"){
		nGroups <- suppressWarnings(as.numeric(readline("Number of groups: ")))
		while(is.na(nGroups)| nGroups<1 | !is.wholenumber(nGroups)){
			nGroups <- suppressWarnings(as.numeric(readline("\n**** Number of groups must be an integer above 0 ****\nNumber of groups: ")))
		}
	}


	if(plot_type %in% c("mean_error","boxplot")){
		output$raw_data <- raw_data <- groups_extract(plot_type=plot_type, nGroups=nGroups, image=image, image_file=image_file, calpoints=calpoints, point_vals=point_vals)	
		cal_data <- calibrate(raw_data=raw_data,calpoints=calpoints, point_vals=point_vals)
		output$processed_data <- convert_group_data(cal_data=cal_data, plot_type=plot_type, nGroups=nGroups)
		if(plot_type == "mean_error") {
			error_type <- readline("Type of error (se, CI95, sd, range): ")
			while(!error_type %in% c("se","CI95","sd","range")) error_type <- readline("**** Invalid error type ***\nType of error (se, CI95, sd, range): ")
			output$error_type <- error_type
		}
		output$processed_data$variable <- variable
	}
	
	if(plot_type == "scatterplot"){
		output$raw_data <- raw_data <- group_scatter_extract(nGroups,image=image, image_file=image_file, calpoints=calpoints, point_vals=point_vals)
		output$processed_data <- calibrate(raw_data=raw_data,calpoints=calpoints, point_vals=point_vals)
		output$processed_data$x_variable <- x_variable
		output$processed_data$y_variable <- y_variable
	}	

	if(plot_type == "histogram"){
		output$raw_data <- raw_data <- histogram_extract(image=image, image_file=image_file, calpoints=calpoints, point_vals=point_vals)
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
	fn <- filename(object$image_file)

	if (object$plot_type == "mean_error"){
		out <- data.frame(
			filename=fn,
			group_id=pd$id,
			variable=pd$variable,
			mean=pd$mean,
			sd=error_to_sd(error=pd$error, n=pd$n, error_type=object$error_type),
			n=pd$n,
			r=NA
		)
	}
	
	if (object$plot_type == "boxplot"){
		out <- data.frame(
			filename=fn,
			group_id=pd$id,
			variable=pd$variable,
			mean=rqm_to_mean(min=pd$min,LQ=pd$q1,median=pd$med,UQ=pd$q3,max=pd$max),
			sd=rqm_to_sd(min=pd$min,LQ=pd$q1,UQ=pd$q3,max=pd$max,n=pd$n),
			n=pd$n,
			r=NA
		)
	}

	if (object$plot_type=="scatterplot"){
		out <- as.data.frame(do.call(rbind, lapply(split(pd,pd$id), function(z){ 
			data.frame(
				filename=fn,
				group_id=z$id[1],
				variable=c(z$x_variable[1],z$y_variable[1]),
				mean=apply(z[,c("x","y")],2,mean),
				sd=apply(z[,c("x","y")],2,sd),
			 	n=nrow(z),
			 	r=cor(z$x,z$y)
			)
		})))
		rownames(out) <- 1:nrow(out)
	}

	if (object$plot_type=="histogram"){
		hist_data <- rep(pd$midpoints, pd$freq)
		out <- data.frame(
			filename=fn,
			group_id=NA,
			variable=pd$variable[1],
			mean=mean(hist_data),
			sd=sd(hist_data),
			n=length(hist_data),
			r=NA
		)
	}
	out$plot_type <- object$plot_type
	return(out)
}




#' @title plot.metaDigitise
#' @param x an R object of class ‘metaDigitise’ 
#' @param ... further arguments passed to or from other methods.
#' @description Re-plots figure and extraction data
#' @author Joel Pick
#' @export

plot.metaDigitise <- function(x,...){
	op <- par(mar=c(3,0,1,0))
	image <- magick::image_read(x$image_file)
	new_image <- rotate_graph(image=image, flip=x$flip, rotate=x$rotate)
	internal_redraw(image=new_image, image_file=x$image_file, plot_type=x$plot_type, calpoints=x$calpoints, point_vals=x$point_vals, raw_data=x$raw_data)
	on.exit(par(op))
}


#' @title internal_digitise
#' @description Extracts points from a single figure and processes data
#' @param image_file Image file
#' @param plot_type Type of plot from "mean_error","boxplot","scatterplot" or"histogram". Function will prompt if not entered by user.
#' @return List of 
#' @author Joel Pick
#' @export

internal_digitise <- function(image_file, plot_type=NULL){
		
	output <- list()
	output$image_file <- image_file

	### image rotation
	rotate_image <- user_rotate_graph(image_file)
	output$flip <- rotate_image$flip
	output$rotate <- rotate_image$rotate

	flush.console()
	
	### plot type
	output$plot_type <- plot_type <- if(is.null(plot_type)){specify_type()}else{plot_type}
	stopifnot(plot_type %in% c("mean_error","boxplot","scatterplot","histogram"))

	### variables
	output$variable <- ask_variable(plot_type)

	### Calibrate axes
	cal <- user_calibrate(output)
	output$calpoints <- cal$calpoints
	output$point_vals <- cal$point_vals


	### N entered?
	if(plot_type %in% c("mean_error","boxplot")) {
		askN <- user_options("\nEnter sample sizes? y/n ",c("y","n"))
		output$entered_N <- ifelse(askN =="y", TRUE, FALSE)
	}else{
		output$entered_N <- TRUE
	}
		
	### Extract data
	output$raw_data <- point_extraction(output)

	## error type
	if(plot_type %in% c("mean_error")) {
		output$error_type <- user_options("\nType of error (se, CI95, sd): ", c("se","CI95","sd"))
	}

	### calibrate and convert data
	output$processed_data <- process_data(output)

	class(output) <- 'metaDigitise'
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
	cat(paste("Figure identified as", x$plot_type, "with", length(unique(x$raw_data$id)), "groups","\n"))
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
		out <- as.data.frame(do.call(rbind, c(lapply(split(pd,pd$id), function(z){ 
					data.frame(
						filename=fn,
						group_id=z$id[1],
						variable=c(z$x_variable[1],z$y_variable[1]),
						mean=apply(z[,c("x","y")],2,mean),
						sd=apply(z[,c("x","y")],2,sd),
					 	n=nrow(z),
					 	r=cor(z$x,z$y)
					)
				}),make.row.names=FALSE)))
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
	do.call(internal_redraw, x)
}

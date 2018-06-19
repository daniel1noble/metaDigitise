#' @title calibrate
#' @param raw_data The raw data
#' @param calpoints The calibration points
#' @param point_vals The point values
#' @param log_axes whether x or y is logged
#' @param ... further arguments passed to or from other methods
#' @description Converts x and y coordinates from original plot coords to actual coords using previous identified coordinates. Modified from digitise package

calibrate <- function(raw_data, calpoints, point_vals, log_axes, ...) {
	
	ylog <- "y" %in% log_axes["axes"]
	xlog <- "x" %in% log_axes["axes"]
	base <- as.numeric(if(length(log_axes)>1 & log_axes["base"]=="e"){ exp(1) }else{log_axes["base"]})

	if(ylog & log_axes["transformed"]=="s") point_vals[1:2] <- log(point_vals[1:2], base=base)
	if(xlog & log_axes["transformed"]=="s") point_vals[3:4] <- log(point_vals[3:4], base=base)

	cy <- stats::lm(formula = point_vals[1:2] ~ calpoints$y[1:2])$coeff
 	raw_data$y <- raw_data$y * cy[2] + cy[1]

 	if(nrow(calpoints)==4){
		cx <- stats::lm(formula = point_vals[3:4] ~ calpoints$x[3:4])$coeff
		raw_data$x <- raw_data$x * cx[2] + cx[1]
	}else{
		raw_data$x <- raw_data$x 
	}

	if(ylog & log_axes["base"]=="e") raw_data$y <- exp(raw_data$y)
	if(ylog & log_axes["base"]!="e") raw_data$y <- base^raw_data$y
	if(xlog & log_axes["base"]=="e") raw_data$x <- exp(raw_data$x)
	if(xlog & log_axes["base"]!="e") raw_data$x <- base^raw_data$x

	return(raw_data)
}



#' @title convert_group_data
#' @param cal_data Calibrated data
#' @param plot_type The type of plot
#' @description Converts, pre-calibrated points clicked into a meaningful dataframe 

convert_group_data <- function(cal_data, plot_type){
	convert_data <- data.frame()

	for(i in unique(cal_data$id)) {
		group_data <- subset(cal_data,cal_data$id==i)

		if(plot_type == "mean_error") {
			convert_data <- rbind(convert_data, data.frame(id=i, mean=group_data$y[2], error=abs(group_data$y[1] - group_data$y[2]), n=group_data$n[1]))
		}

		if(plot_type == "boxplot") {
			convert_data <- rbind(convert_data, data.frame(id=i, max=group_data[1,"y"], q3=group_data[2,"y"], med=group_data[3,"y"], q1=group_data[4,"y"], min=group_data[5,"y"], n=group_data$n[1]))
		}
	}
	return(convert_data)
}



#' @title convert_histogram_data 
#' @param cal_data The calibration data
#' @description Conversion of extracted data from histogram

convert_histogram_data <- function(cal_data){
	convert_data <- data.frame()

	for(i in unique(cal_data$bar)){
		bar_data <- subset(cal_data, cal_data$bar==i) # need to have object that bar is from
		convert_data <- rbind( convert_data, data.frame(id=cal_data$id[1], midpoints=mean(bar_data$x), frequency= round(mean(bar_data$y)) ) )
	}
	return(convert_data)
}




#' @title process_data
#' @param object object from metaDigitise
#' @description Processes points clicked into a meaningful dataframe 

process_data <- function(object){

	plot_type <- object$plot_type
	variable <- object$variable

	if(plot_type %in% c("mean_error","boxplot")){
		cal_data <- do.call(calibrate, object)
		processed_data <- convert_group_data(cal_data=cal_data, plot_type=plot_type)
		processed_data$variable <- variable
	}
	
	if(plot_type == "scatterplot"){
		processed_data <- do.call(calibrate, object)
		processed_data$y_variable <- variable["y"]
		processed_data$x_variable <- variable["x"]
	}	

	if(plot_type == "histogram"){
		cal_data <- do.call(calibrate, object)
		processed_data <- convert_histogram_data(cal_data=cal_data)
		processed_data$variable <- variable
	}

	return(processed_data)
}
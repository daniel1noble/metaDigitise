point_extraction <-function(object){

	plot_type <- object$plot_type

	if(plot_type %in% c("mean_error","boxplot")){
		raw_data <- do.call(MB_extract, object)
	}

	if(plot_type == "scatterplot"){
		raw_data <- do.call(group_scatter_extract, object)
	}	
	
	if(plot_type == "histogram"){
		raw_data <- do.call(histogram_extract, object)
	}

	return(raw_data)
}
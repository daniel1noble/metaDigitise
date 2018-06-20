#' @title point_extraction
#' @description Extracts or edits point of a digitisation
#' @param object Object
#' @param edit Logical (TRUE or FALSE) indicating whether a point would like to be edited


point_extraction <-function(object, edit=FALSE){

	plot_type <- object$plot_type

	if(plot_type %in% c("mean_error","boxplot")){
		raw_data <- do.call(MB_extract, c(object,edit=edit))
	}

	if(plot_type == "scatterplot"){
		raw_data <- do.call(group_scatter_extract, c(object,edit=edit))
	}	
	
	if(plot_type == "histogram"){
		raw_data <- do.call(histogram_extract, c(object,edit=edit))
	}

	return(raw_data)
}
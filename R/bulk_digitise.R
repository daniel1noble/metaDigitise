#' @title bulk_digitise
#' @description Batch processes png files within a set directory, consolidates the data and exports the data for each image and type
#' @param dir the path name to the directory / folder where the files are located
#' @param types Argument specifying whether the types of images are the same (i.e., all scatter plots - "same") or a mixture of different plot types (i.e., scatter plots, means and se - "diff").
#' @return If type = "same" the function returns a dataframe with the relevant data for each figure being digitised. If type = "diff" it returns a list of the relevant data.
#' @export

bulk_digitise <- function(dir, types = c("diff", "same")){
	  type <- match.arg(types)
	images <- list.files(dir)
	 paths <- paste0(dir, images)

	 if(types == "diff"){
	 data_list <- list()
	 for(i in 1:length(paths)){
	 			 plot_type <- specify_type()
		 	data_list[[i]] <- extract_points(paths[i], plot_type = plot_type)
		 	names(data_list)[i] <- images[i]
	 	}
	}

	if(types == "same"){
		plot_type <- specify_type()
		data_list <- list()
		for(i in 1:length(paths)){
	 			 plot_type <- specify_type()
		 	data_list[[i]] <- extract_points(paths[i], plot_type = plot_type)
		 	names(data_list)[i] <- images[i]
	 	}	
	}

	if(type == "diff"){
		return(data_list)
	} else{
		return(do.call(rbind, data_list))
	}
}

#' @title specify_type
#' @description Function that allows user to interface with function to specific each type of plot prior to digitising
specify_type <- function(){
		#user enters numeric value to specify the plot BEFORE moving on
	 	pl_type <- readline("Please specify the plot_type numerically as either: 1) mean_se, 2) box plot or 3) scatter plot: ")
	 	plot_type <- ifelse(pl_type == "1", "mean_se", ifelse(pl_type == "2", "boxplot","scatterplot"))
	 	return(plot_type)
}
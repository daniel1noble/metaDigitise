#' @title bulk_digitise
#' @description Batch processes png files within a set directory, consolidates the data and exports the data for each image and type
#' @param dir the path name to the directory / folder where the files are located
#' @param types Argument specifying whether the types of images are the same (i.e., all scatter plots - "same") or a mixture of different plot types (i.e., scatter plots, means and se - "diff").
#' @return If type = "same" the function returns a dataframe with the relevant data for each figure being digitised. If type = "diff" it returns a list of the relevant data.
#' @export

bulk_metaDigitise <- function(dir, types = c("diff", "same")) {
	  
	  cal_dir <- paste0(dir, "caldat")

	if (dir.exists(cal_dir) == FALSE){
		dir.create(cal_dir)
	}

	  type <- match.arg(types)
	images <- list.files(dir, pattern = ".[pjt][dnip][fpg]*")
	  name <- gsub(".[pjt][dnip][fpg]*", "", images)
	 paths <- paste0(dir, images)

	 if (type == "diff") {
		 data_list <- list()
		 for (i in 1:length(paths) ) {
		 		   	   plot_type <- specify_type()
			      tmp <- metaDigitise(paths[i], plot_type = plot_type)
			      data_list[[i]] <- tmp
			 names(data_list)[i] <- images[i]
			 saveRDS(tmp, file = paste0(cal_dir, "/",name[i]))
		 	}
	}

	if (type == "same") {
		plot_type <- specify_type()
		data_list <- list()
		
		for (i in 1:length(paths)) {
		 	tmp <- metaDigitise(paths[i], plot_type = plot_type)
		 	names(data_list)[i] <- images[i]
		 	data_list[[i]] <- tmp
		 	saveRDS(tmp, file = paste0(cal_dir, "/", name[i]))
	 	}	
	}

	if (type == "diff") {
		return(extract_digitised(data_list))
	} else{
		return(do.call(rbind, extract_digitised(data_list)))
	}
}

#' @title specify_type
#' @description Function that allows user to interface with function to specific each type of plot prior to digitising
#' @return The function will return the type of plot specified by the user and feed this argument back into metDigitise 
#' @export

specify_type <- function(){
		#user enters numeric value to specify the plot BEFORE moving on
	 	pl_type <- NA
	 	#while keeps asking the user the question until the input is one of the options
		while(!pl_type %in% c("m","b","s","h")) pl_type <- readline("Please specify the plot_type as either: mean and error, box plot, scatter plot or histogram m/b/s/h: ")
	
	 	plot_type <- ifelse(pl_type == "m", "mean_error", ifelse(pl_type == "b", "boxplot",ifelse(pl_type == "s", "scatterplot","histogram")))
	
	return(plot_type)
}

#' @title extract_digitised
#' @param list A list of objects returned from metaDigitise
#' @description Function for extracting the data from a metaDigitise list
#' @return The function will return a data frame with the data across all the digitised files 
#' @export

extract_digitised <- function(list) {
	return( do.call (rbind, lapply (list, function(x) x$processed_data) ))
}

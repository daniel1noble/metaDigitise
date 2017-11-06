#' @title single_MB_extract
#' @param plot_type Type of plot
#' @description Takes points user defined points from a single group mean_error plot or boxplot, in a set order, and returns them.
single_MB_extract <- function(plot_type){
	
	if(plot_type=="mean_error"){
		cat("\nClick on Error Bar, followed by the Mean\n\n")
		group_points <- locator(2, type="o", col="red", lwd=2, pch=19)
	}

	if(plot_type=="boxplot"){
		cat("\nClick on Max, Upper Q, Median, Lower Q, and Minimum\nIn that order\n\n")
		group_points <- locator(5, type="o", col="red", lwd=2, pch=19)
		if(group_points$y[1]<group_points$y[5]) warning("max is smaller than min - consider deleting and re-adding group", call. = FALSE, immediate. = TRUE)
	}

	return(group_points)
}

#' @title MB_extract
#' @param edit logical; whether in edit mode 
#' @param plot_type The type of plot
#' @param entered_N ask for sample sizes?
#' @param raw_data raw data
#' @param ... further arguments to internal_redraw
#' @description Extraction of data from boxplots of mean_error plots, from multiple groups


MB_extract <- function(edit=FALSE, plot_type, entered_N, raw_data = data.frame(), ...){

	add_removeQ <- if(edit){ "b" }else{ "a" }

	while(add_removeQ != "f"){
		
		if(add_removeQ=="a"){
			group_id <- user_unique(paste("\nGroup identifier: "), unique(raw_data$id))
			group_N <- if(entered_N){ user_count("\nGroup sample size: ") }else{ NA }
			group_points <- single_MB_extract(plot_type)
			raw_data <- rbind(raw_data, data.frame(id=group_id,x=group_points$x,y=group_points$y, n=group_N))
		}

		if(add_removeQ=="e"){
			group_id <- unique(raw_data$id)[ menu(unique(raw_data$id)) ]
			group_data <- subset(raw_data, id==group_id)
			raw_data <- subset(raw_data, id != group_id)
			idQ <- user_options("\nChange group identifier? (y/n) ",c("y","n"))
			if(idQ=="y") {
				group_data$id <- user_unique("\nGroup identifier: ", unique(raw_data$id))
				internal_redraw(plot_type=plot_type, raw_data=rbind(raw_data, group_data),...)
			}

			nQ <- user_options("\nChange group sample size? (y/n) ",c("y","n"))
			if(nQ=="y") {
				group_data$n <- user_count("\nGroup sample size: ")
				internal_redraw(plot_type=plot_type, raw_data=rbind(raw_data, group_data),...)
			}

			pointsQ <- user_options("\nReclick group points? (y/n) ",c("y","n"))
			if(pointsQ=="y"){
				internal_redraw(plot_type=plot_type, raw_data=raw_data,...)
				group_points <- single_MB_extract(plot_type)
				group_data$x=group_points$x
				group_data$y=group_points$y
			}			
			raw_data <- rbind(raw_data, group_data)
		}

		if(add_removeQ=="d") raw_data <- delete_group(raw_data)


		internal_redraw(plot_type=plot_type, raw_data=raw_data,...)
		add_removeQ <- readline("Add group, Edit Group, Delete group or Finish plot? a/e/d/f ")

	}
	return(raw_data)
}



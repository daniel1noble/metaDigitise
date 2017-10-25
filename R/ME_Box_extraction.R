#' @title single_group_extract
#' @param plot_type Type of plot
#' @description Takes points user defined points from a single group mean_error plot or boxplot, in a set order, and returns them.
single_MB_extract <- function(plot_type){
	
	if(plot_type=="mean_error"){
		cat("\nClick on Error Bar, followed by the Mean\n\n")
		group_points <- locator(2, type="o", col="red", lwd=2, pch=19)
		points(group_points$x[1],group_points$y[1], pch=20, col="yellow")
	}

	if(plot_type=="boxplot"){
		cat("\nClick on Max, Upper Q, Median, Lower Q, and Minimum\nIn that order\n\n")
		group_points <- locator(5, type="o", col="red", lwd=2, pch=19)
	}

	return(group_points)
}

#' @title groups_extract
#' @param plot_type The type of plot
#' @param nGroups number of groups
#' @param image_file image file name
#' @param image_details image details
#' @param calpoints points used for calibration 
#' @param point_vals values for calibration
#' @param entered_N ask for sample sizes?
#' @param ... further arguments passed to or from other methods.
#' @description Extraction of data from boxplots of mean_error plots, from multiple groups
MB_extract <- function(plot_type, nGroups, image_file, image_details, calpoints, point_vals,entered_N,...){

	nRows <- ifelse(plot_type=="mean_error",2,5)
	raw_data <- as.data.frame(matrix(NA, ncol=4, nrow=nGroups*nRows, dimnames=list(NULL, c("id","x","y","n"))))
	image_width <- image_details["width"]
	image_height <- image_details["height"]

	if(plot_type == "mean_error"){
		points((image_width/4)*c(1,3,3), rep(-image_height/40,3), pch=c(19,19,20), col=c("red","red","yellow"),xpd=TRUE)
		text((image_width/4)*c(1,3), rep(-image_height/20,2), c("mean","error"),xpd=TRUE)
	}
	
	for(i in 1:nGroups) {
		rowStart <- (i-1)*nRows +1
		rows<- rowStart:(rowStart+nRows-1)
		add_removeQ <- "r"
		while(add_removeQ=="r") {
			
	#		if(nGroups>1){
			group_id <- readline(paste("\nGroup identifier",i,": "))
			while(group_id %in% unique(raw_data$id)){group_id <- readline(paste("**** Group identifiers must be unique ****\nGroup identifier",i,": "))}
	#		}else{group_id <- ""}
			raw_data[rows,"id"] <- group_id

			group_N <- if(entered_N){ user_count("\nGroup sample size: ") }else{ NA }
			raw_data[rows,"n"] <- group_N

			group_points <- single_MB_extract(plot_type)
			text(mean(group_points$x)+image_width/30,mean(group_points$y),paste0(group_id," (",group_N,")"),srt=90, col="Red")
			raw_data[rows,"x"] <- group_points$x
			raw_data[rows,"y"] <- group_points$y

			if(plot_type=="boxplot" & group_points$y[1]<group_points$y[5]) warning("max is smaller than min", call. = FALSE, immediate. = TRUE)

			add_removeQ <- readline("\nContinue or reclick? c/r ")
			while(!add_removeQ  %in% c("c","r")) add_removeQ <- readline("Continue or reclick? c/r ")	
			if(add_removeQ=="r") {
				internal_redraw(image_file=image_file, plot_type=plot_type, calpoints=calpoints, point_vals=point_vals, raw_data=raw_data[-rows,])
				raw_data[rows,"id"] <- NA
			}		
		}
	}
	return(raw_data)
}




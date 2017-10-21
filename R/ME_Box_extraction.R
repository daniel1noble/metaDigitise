#' @title single_group_extract
#' @param plot_type Type of plot
#' @description Takes points user defined points from a single group mean_error plot or boxplot, in a set order, and returns them.
single_group_extract <- function(plot_type){
	
	if(plot_type=="mean_error"){
		cat("Click on upper error bar, followed by the Mean\n")
		group_points <- locator(2, type="o", col="red", lwd=2, pch=19)
	}

	if(plot_type=="boxplot"){
		cat("Click on Max, Upper Q, Median, Lower Q, and Minimum\nIn that order\n")
		group_points <- locator(5, type="o", col="red", lwd=2, pch=19)
	}

	return(group_points)
}

#' @title groups_extract
#' @param plot_type The type of plot
#' @param nGroups number of groups
#' @param image image
#' @param calpoints points used for calibration 
#' @param point_vals values for calibration
#' @description Extraction of data from boxplots of mean_error plots, from multiple groups
groups_extract <- function(plot_type, nGroups, image, calpoints, point_vals){
	askN <- NA
	while(!askN %in% c("y","n")) askN <- readline("Enter sample sizes? y/n ")

	nRows <- ifelse(plot_type=="mean_error",2,5)
	raw_data <- as.data.frame(matrix(NA, ncol=4, nrow=nGroups*nRows, dimnames=list(NULL, c("id","x","y","n"))))
	image_width <- magick::image_info(image)["width"][[1]]
	
	for(i in 1:nGroups) {
		rowStart <- (i-1)*nRows +1
		rows<- rowStart:(rowStart+nRows-1)
		add_removeQ <- "r"
		while(add_removeQ=="r") {
			
			if(nGroups>1){
				group_id <- readline(paste("Group identifier",i,": "))
				while(group_id %in% unique(raw_data$id)){group_id <- readline(paste("**** Group identifiers must be unique ****\nGroup identifier",i,": "))}
			}else{group_id <- ""}
			raw_data[rows,"id"] <- group_id

			if(askN=="y") raw_data[rows,"n"] <- readline(paste("Group sample size: "))

			group_points <- single_group_extract(plot_type)
			text(mean(group_points$x)+image_width/30,mean(group_points$y),group_id,srt=90, col="Red")
			raw_data[rows,"x"] <- group_points$x
			raw_data[rows,"y"] <- group_points$y
			add_removeQ <- readline("Continue or reclick? c/r ")
			while(!add_removeQ  %in% c("c","r")) add_removeQ <- readline("Continue or reclick? c/r ")	
			if(add_removeQ=="r") {
				internal_redraw(image, plot_type=plot_type, calpoints, point_vals, raw_data[-rows,])
				raw_data[rows,"id"] <- NA
			}		
		}
	}
	return(raw_data)
}

#' @title convert_group_data
#' @param cal_data Calibrated data
#' @param plot_type The type of plot
#' @param nGroups number of groups
#' @description Converts, pre-calibrated points clicked into a meaningful dataframe 
convert_group_data <- function(cal_data, plot_type, nGroups){
	nRows <- ifelse(plot_type=="mean_error",2,5)
	convert_data <- as.data.frame(matrix(NA, ncol=nRows+2, nrow=nGroups))
	colnames(convert_data) <- if(plot_type=="mean_error"){c("id","mean","error","n")}else{c("id","max","q3","med","q1","min","n")}

	for(i in 1:nGroups) {
		rowStart <- (i-1)*nRows +1
		group_data <- cal_data[rowStart:(rowStart+nRows-1),]

		if(plot_type == "mean_error") {
			group_mean <- group_data$y[2]
			group_se <- group_data$y[1] - group_data$y[2]
			convert_data[i,] <- c(group_data$id[1], group_mean,group_se,group_data$n[1])
		}

		if(plot_type == "boxplot") {
			convert_data[i,] <- c(group_data$id[1],group_data[,"y"], group_data$n[1])
		}
	}
	return(convert_data)
}


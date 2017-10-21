#' @title find_nearest_point
#' @description find nearest point
#' @param raw_data raw_data
#' @param image_width image_width 
#' @param image_height image_height
find_nearest_point<-function(raw_data,image_width,image_height){

#	cat("Click on point you want to remove\n")
	remove <- locator(1,type="p", col="green", pch=4, lwd=2)
	x_remove <- which(abs(raw_data$x-remove$x) == min(abs(raw_data$x-remove$x)))
	y_remove <- which(abs(raw_data$y-remove$y) == min(abs(raw_data$y-remove$y)))
	## add in a maximum distance to search in; at the moment it searches whole plot area
	#

	if(length(x_remove)>1 & length(y_remove)>1){
		cat("**** Point not identified ****\n")
	}else if(length(x_remove)>1 & length(y_remove)==1){
		x_remove <- x_remove[x_remove %in% y_remove]
		raw_data <- raw_data[-x_remove,]
		internal_redraw(image, plot_type="scatterplot", calpoints, point_vals, raw_data)
		cat("**** Point successfully removed ****\n")
	}else if(length(y_remove)>1 & length(x_remove)==1){
		y_remove <- y_remove[y_remove %in% x_remove]
		raw_data <- raw_data[-x_remove,]
		internal_redraw(image, plot_type="scatterplot", calpoints, point_vals, raw_data)
		cat("**** Point successfully removed ****\n")
	}else if(x_remove==y_remove) {
		raw_data <- raw_data[-x_remove,]
		internal_redraw(image, plot_type="scatterplot", calpoints, point_vals, raw_data)
		cat("**** Point successfully removed ****\n")	
	}else{cat("**** Point not identified ****\n")
	}


# image <- image_read("/Users/joelpick/Dropbox/0_postdoc/10_metaDigitise/example_figs/histogram.png")
#  plot(image)

# pp <- locator(1, type="o")

# image_width <- image_info(fig)["width"]
# image_height <- image_info(fig)["height"]

# #search area
# search_fraction <- 40
# polygon(c(pp$x+width/search_fraction,pp$x+width/search_fraction,pp$x-width/search_fraction,pp$x-width/search_fraction,pp$x+width/search_fraction), c(pp$y-height/search_fraction,pp$y+height/search_fraction,pp$y+height/search_fraction,pp$y-height/search_fraction,pp$y-height/search_fraction))


}

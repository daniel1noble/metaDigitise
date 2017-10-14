#' @title mean_se_points
#' @description Takes points user defined points for mean and se, in a set order, and returns them.
#' @param axis_coords List output from cal_coords
#' @return data.frame
#' @author Joel Pick
mean_se_points <- function(axis_coords){
	calpoints <- axis_coords$calpoints
	point_vals <- axis_coords$point_vals
	cat("Now click on Upper SE, followed by the Mean\n")
	group_points <- locator(2, type="o", col="red", lwd=2)
	group_points_cal <- digitize::Calibrate(group_points, calpoints, point_vals[1], point_vals[2], point_vals[3], point_vals[4])
	group_mean <- group_points_cal$y[2]
	group_se <- group_points_cal$y[1] - group_points_cal$y[2]	
	c(group_mean,group_se,mean(group_points_cal$x))
	}
	
#' @title boxplot_points
#' @description Takes points user defined points from a boxplot, in a set order, and returns them.
#' @param axis_coords List output from cal_coords
#' @return data.frame
#' @author Joel Pick
boxplot_points <- function(axis_coords){
	calpoints <- axis_coords$calpoints
	point_vals <- axis_coords$point_vals
	cat("Now click on Max, Upper Q, Median, Lower Q, and Minimum\nIn that order\n")
	group_points <- locator(5, type="o", col="red", lwd=2)
	group_points_cal <- digitize::Calibrate(group_points, calpoints, point_vals[1], point_vals[2], point_vals[3], point_vals[4])
	c(group_points_cal[,"y"],mean(group_points_cal$x))
	}



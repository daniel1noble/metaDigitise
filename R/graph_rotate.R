#' @title graph_rotate
#' @description Rotates imported figures in order to align them properly. Asks the user after each rotation if further rotation is required
#' @param image Image object from magick::image_read
#' @return Returns new image object and plots rotated image
#' @author Joel Pick
#' @export
graph_rotate <- function(image){
	plot(image)
	rotateQ <- NA
	while(!rotateQ %in% c("y","n")) rotateQ <- base::readline("Rotate Image? y/n ")
	while(rotateQ=="y"){
	print("click left hand then right hand side of x axis")
	
	##rotate
	##click left hand then right hand side of x axis
	rot_angle <- locator(2, col="green")
	rot_angle$y
	
	x.dist <- rot_angle$x[2] - rot_angle$x[1]
	y.dist <- rot_angle$y[2] - rot_angle$y[1]
	
	f <- atan2(y.dist, x.dist) * 180/pi
	image <- magick::image_rotate(image, f)
	plot(image)
	rotateQ <- base::readline("Rotate Image? y/n ")}
	return(image)
}
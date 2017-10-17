#' @title graph_rotate
#' @description Rotates imported figures in order to align them properly. Asks the user after each rotation if further rotation is required
#' @param image Image object from magick::image_read
#' @return Returns new image object and plots rotated image
#' @author Joel Pick
#' @export
graph_rotate <- function(image){
	plot(image)
	rotateQ <- "a"
cat("mean_error and boxplots should be vertically orientated
       _ 
       |	
  I.E. o    NOT  |-o-|
       |
       _

If they are not then chose flip to correct this.

If figures are wonky, chose rotate.

Otherwise chose continue\n
")

	while(rotateQ != "c") {
		if(rotateQ=="f"){
			image <- magick::image_flop(magick::image_rotate(image,270))
			plot(image)
		}
		if(rotateQ=="r"){
			cat("Click left hand then right hand side of x axis\n")
			
			rot_angle <- locator(2, col="green")
			rot_angle$y
			
			x.dist <- rot_angle$x[2] - rot_angle$x[1]
			y.dist <- rot_angle$y[2] - rot_angle$y[1]
			
			f <- atan2(y.dist, x.dist) * 180/pi
			image <- magick::image_rotate(image, f)
			plot(image)
		}
		rotateQ <- base::readline("Flip, rotate or continue f/r/c ")
	}
#	return(image)
}


## scatterplot - identify trait on x and trait on y
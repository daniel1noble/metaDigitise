#' @title user_rotate_graph
#' @description Rotates/flips imported figures according to user input, in order to align them properly. Asks the user after each change if further alteration is required
#' @param image_file Image filename

user_rotate_graph <- function(image_file){
	image <- magick::image_read(image_file)
	plot(image)
	mtext(filename(image_file),3, 0)

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
	out <- list(flip=FALSE, rotate=0)
	while(rotateQ != "c") {
		if(rotateQ=="f"){
			image <- magick::image_flop(magick::image_rotate(image,270))
			if(!out$flip){out$flip <- TRUE}else{out$flip <- FALSE}
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
			out$rotate <- out$rotate + f
		}
		rotateQ <- base::readline("Flip, rotate or continue f/r/c ")
	}
	out$image <- image
	return(out)
}



#' @title rotate_graph
#' @description Rotates/flips imported figures
#' @param image Image object from magick::image_read
#' @param flip whether to flip figure
#' @param rotate how much to rotate figure

rotate_graph <- function(image, flip, rotate){
	if(flip) image <- magick::image_flop(magick::image_rotate(image,270))
	image <- magick::image_rotate(image, rotate)
	return(image)
}
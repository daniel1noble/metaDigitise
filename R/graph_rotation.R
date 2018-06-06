#' @title user_rotate_graph
#' @description Rotates/flips imported figures according to user input, in order to align them properly. Asks the user after each change if further alteration is required
#' @param image_file Image filename

user_rotate_graph <- function(image_file){

cat("
**** NEW PLOT ****


mean_error and boxplots should be vertically orientated
       _ 
       |	
  I.E. o    NOT  |-o-|
       |
       _

If they are not then chose flip to correct this.

If figures are wonky, chose rotate.

Otherwise chose continue\n
")
	
	flip=FALSE
	rotate=0

	rotateQ <- "a"
	while(rotateQ != "c") {
		if(rotateQ=="f"){
			flip <- ifelse(!flip, TRUE, FALSE)
		}
		if(rotateQ=="r"){
			cat("Click left hand then right hand side of x axis\n")
			
			rot_angle <- graphics::locator(2, col="green")			
			x.dist <- rot_angle$x[2] - rot_angle$x[1]
			y.dist <- rot_angle$y[2] - rot_angle$y[1]
			
			f <- atan2(y.dist, x.dist) * 180/pi
			rotate <- rotate + f
		}
		internal_redraw(image_file, flip = flip, rotate = rotate)	
		rotateQ <- readline("Flip, rotate or continue (f/r/c) \n")
	}

	out <- list(flip=flip, rotate=rotate)

	return(out)
}


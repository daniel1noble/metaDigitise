#' @title getVals
#' @description Gets values needed to calibrate axis coordinated. Modified from the digitize package
#' @return vector
#' @author Joel Pick
getVals <- function() {
	names <- c("x1","x2","y1","y2")
	vals <- NULL
	for (p in names) {
    	bad <- TRUE
    	while (bad) {
    		input <- base::readline(paste("What is the value of", p, "?\n"))
      		bad <- length(input) > 1
      		if (bad) {
        		cat("Error in input! Try again\n")
      		} else {
        		bad <- FALSE
      		}
    	}
    vals[p] <- as.numeric(input)
  }
  return(vals)
}

#' @title cal_coords
#' @description Prompts user to enter axis coordinates, and their values. Modified from the digitize package
#' @return list
#' @author Joel Pick
cal_coords <- function() {

		cat( "Use your mouse, and the image, 
but careful how you calibrate.
Click IN ORDER: x1, x2, y1, y2 \n
	
    Step 1 ----> Click on x1
  |
  |
  |
  |
  |
  |_____x1__________________
\n
    Step 2 ----> Click on x2
  |
  |
  |
  |
  |
  |___________________x2____
\n
    Step 3 ----> Click on y1
  |
  |
  |
  |
  y1
  |_________________________
\n
    Step 4 ----> Click on y2
  |
  y2
  |
  |
  |
  |_________________________
"
	 )
	
	calpoints <- locator(4, type="p", col="blue", pch=3, lwd = 2)
	flush.console()
	point_vals <- getVals()  
  return(list(calpoints=calpoints,point_vals=point_vals))
}

#Range <- function(x, na.rm=TRUE) max(x, na.rm=na.rm) - min(x, na.rm=na.rm)

#' @title cal_X
#' @description Converts x coordinates to using previous identified coordinates and conversion
#' @return vector
#' @author Joel Pick
cal_X <- function(x, axis_coords) {
  cx <- lm(formula = point_vals[1:2] ~ calpoints$x[1:2])$coeff
  x * cx[2] + cx[1]
}


#' @title cal_Y
#' @description Converts x coordinates to using previous identified coordinates and conversion
#' @return vector
#' @author Joel Pick
cal_Y <- function(y axis_coords) {
  cy <- lm(formula = c(y1, y2) ~ c(y))$coeff
  y * cy[2] + cy[1]
}
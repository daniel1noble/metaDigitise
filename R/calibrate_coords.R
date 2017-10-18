#' @title getVals
#' @description Gets values needed to calibrate axis coordinated. Modified from the digitize package
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
  return(calpoints)
}


#Range <- function(x, na.rm=TRUE) max(x, na.rm=na.rm) - min(x, na.rm=na.rm)

#' @title calibrate
#' @description Converts x and y coordinates from original plot coords to actual coords using previous identified coordinates. Modified from digitise package
calibrate <- function(raw_data, calpoints, point_vals) {
  cx <- lm(formula = point_vals[1:2] ~ calpoints$x[1:2])$coeff
  cy <- lm(formula = point_vals[3:4] ~ calpoints$y[3:4])$coeff
  raw_data$x <- raw_data$x * cx[2] + cx[1]
  raw_data$y <- raw_data$y * cy[2] + cy[1]
  return(raw_data)
}

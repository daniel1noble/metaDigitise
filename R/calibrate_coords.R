#' @title print_cal_instructions
#' @param plot_type plot type
#' @description Prints instructions for calibration
#' 
print_cal_instructions <- function(plot_type){
  cat( "\nOn the Figure, click IN ORDER: 
      y1, y2",if(!plot_type %in% c("mean_error","boxplot")) ", x1, x2", " \n

    Step 1 ----> Click on y1
  |
  |
  |
  |
  y1
  |_________________________
\n
    Step 2 ----> Click on y2
  |
  y2
  |
  |
  |
  |_________________________
  \n",
if(!plot_type %in% c("mean_error","boxplot")) "
    Step 3 ----> Click on x1
  |
  |
  |
  |
  |
  |_____x1__________________
\n
    Step 4 ----> Click on x2
  |
  |
  |
  |
  |
  |___________________x2____

"
   )

}
#print_cal_instructions(plot_type="boxplot")



#' @title cal_coords
#' @param plot_type plot type
#' @description Prompts user to enter axis coordinates, and their values. Modified from the digitize package
cal_coords <- function(plot_type) {
  print_cal_instructions(plot_type)
	calpoints_y <- locator(2, type="o", col="blue", pch=3, lwd = 2)

  calpoints_x <- NULL
  if(!plot_type %in% c("mean_error","boxplot")){
    calpoints_x <- locator(2, type="o", col="blue", pch=3, lwd = 2)
  }

  flush.console()

  return(rbind(as.data.frame(calpoints_y),as.data.frame(calpoints_x)))
}


#' @title getVals
#' @param calpoints Calibration points
#' @param image_width image width
#' @param image_height image height
#' @description Gets values needed to calibrate axis coordinated. Modified from the digitize package
getVals <- function(calpoints, image_width, image_height) {
  names <- if(nrow(calpoints)==2){c("y1","y2")}else{c("y1","y2","x1","x2")}
  vals <- NULL
  for (i in names){
    input <- suppressWarnings( as.numeric(readline(paste("\nWhat is the value of", i, "?\n"))))
    while(is.na(input)){
      input <- suppressWarnings( as.numeric(readline(paste("\n**** Input must be numeric ****\nWhat is the value of", i, "?\n"))))
    }
    vals[i] <- input
  }
  text(calpoints$x[1:2] - c(image_width/30, image_width/30), calpoints$y[1:2] - c(0, 0), vals[1:2], col="blue", cex=2)
  if(nrow(calpoints)==4){
    text(calpoints$x[3:4] - c(0, 0), calpoints$y[3:4] - c(image_height/30, image_height/30), vals[3:4], col="blue", cex=2)
  }
  return(vals)
}


#Range <- function(x, na.rm=TRUE) max(x, na.rm=na.rm) - min(x, na.rm=na.rm)

#' @title calibrate
#' @param raw_data The raw data
#' @param calpoints The calibration points
#' @param point_vals The point values
#' @description Converts x and y coordinates from original plot coords to actual coords using previous identified coordinates. Modified from digitise package
calibrate <- function(raw_data, calpoints, point_vals) {
  cy <- lm(formula = point_vals[1:2] ~ calpoints$y[1:2])$coeff
  raw_data$y <- raw_data$y * cy[2] + cy[1]

  if(nrow(calpoints)==4){
    cx <- lm(formula = point_vals[3:4] ~ calpoints$x[3:4])$coeff
    raw_data$x <- raw_data$x * cx[2] + cx[1]
  }else{
    raw_data$x <- raw_data$x 
  }
  return(raw_data)
}

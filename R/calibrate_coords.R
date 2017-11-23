#' @title print_cal_instructions
#' @param plot_type plot type
#' @param ... further arguments passed to or from other methods.
#' @description Prints instructions for calibration

print_cal_instructions <- function(plot_type,...){
  cat( "\nOn the Figure, click IN ORDER: 
      y1, y2",if(!plot_type %in% c("mean_error","boxplot")) ", x1, x2", " \n

    Step 1 ----> Click on known value on y axis - y1
  |
  |
  |
  |
  y1
  |_________________________
\n
    Step 2 ----> Click on another known value on y axis - y2
  |
  y2
  |
  |
  |
  |_________________________
  \n",
if(!plot_type %in% c("mean_error","boxplot")) "
    Step 3 ----> Click on known value on x axis - x1
  |
  |
  |
  |
  |
  |_____x1__________________
\n
    Step 4 ----> Click on another known value on x axis - x2
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
#' @param ... further arguments passed to or from other methods.
#' @description Prompts user to enter axis coordinates, and their values. Modified from the digitize package

cal_coords <- function(plot_type,...) {
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
#' @param ... further arguments passed to or from other methods.
#' @description Gets values needed to calibrate axis coordinated. Modified from the digitize package

getVals <- function(calpoints,...) {
  names <- if(nrow(calpoints)==2){c("y1","y2")}else{c("y1","y2","x1","x2")}
  vals <- NULL
  for (i in names) vals[i] <- user_numeric(paste("\nWhat is the value of", i, "?"))
  return(vals)
}



#' @title user_calibrate
#' @param object metaDigitise object
#' @description Gets values needed to calibrate axis coordinated. Modified from the digitize package

user_calibrate <- function(object){ 
  cal_Q <- "y"
  while(cal_Q!="n"){
    if(cal_Q == "y"){
      do.call(internal_redraw, c(object, calibration=FALSE, points=FALSE))
      do.call(print_cal_instructions, object)
      object$calpoints <- do.call(cal_coords, object)
      object$point_vals <- do.call(getVals, object)
      do.call(internal_redraw, c(object, calibration=TRUE, points=FALSE))
    }
    cal_Q <- readline("\nRe-calibrate? (y/n) \n")
  }
  return(object[c("calpoints","point_vals")])
  ##output object?
}


#' @title print_cal_instructions
#' @param plot_type plot type
#' @param ... further arguments passed to or from other methods.
#' @description Prints instructions for calibration. Modified from the digitize package

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
#' @param cex size of points
#' @param ... further arguments passed to or from other methods.
#' @description Prompts user to enter axis coordinates, and their values. Modified from the digitize package

cal_coords <- function(plot_type,cex,...) {
	calpoints_y <- locator_mD(2, line=TRUE, col="blue", pch=3, cex=cex)
# graphics::locator(2, type="o", col="blue", pch=3, lwd = 2)

  calpoints_x <- NULL
  if(!plot_type %in% c("mean_error","boxplot")){
    calpoints_x <- locator_mD(2, line=TRUE, col="blue", pch=3, cex=cex)
# graphics::locator(2, type="o", col="blue", pch=3, lwd = 2)
  }

  utils::flush.console()

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

#' @title getVals
#' @param ... further arguments passed to or from other methods.
#' @description Ask user for information about whether axes are on log scale

logAxes <- function(...){
  log_axes <- user_options("\nAre any axes on a log scale? Enter n if none or combination of log axes (x/y/xy)", c("n","x","y","xy","yx"))
  transformed <- if(log_axes == "n"){ NULL } else{ user_options("\nAre these log axes transformed or stretched (t/s)? \nTransformed means the axis is on the log scale, \nstretched means the axis is on the same scale but has been streched out to show log transformation \n(see Readme for examples).", c("t","s")) }
  base <- if(log_axes == "n"){ NULL } else{ user_base() }
  return(c(axes=log_axes,transformed=transformed,base=base))
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
      if(object$plot_type %in% c("boxplot","scatterplot")){
        object$log_axes <- logAxes()
      }else{
        object$log_axes <- c(axes="n",transformed=NULL,base=NULL)
      }      
    }
    cal_Q <- readline("\nRe-calibrate? (y/n) \n")
  }
  return(object[c("calpoints","point_vals","log_axes")])
}



### modified from digitize
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

### rotating images
graph_rotate <- function(image){
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


## from digitize
# Calibrate <- function(data, calpoints, x1, x2, y1, y2)
# {
  # x 		<- calpoints$x[c(1, 2)]
  # y 		<- calpoints$y[c(3, 4)]
  
  # cx <- lm(formula = c(x1, x2) ~ c(x))$coeff
  # cy <- lm(formula = c(y1, y2) ~ c(y))$coeff
  
  # data$x <- data$x * cx[2] + cx[1]
  # data$y <- data$y * cy[2] + cy[1]
  
  # return(as.data.frame(data))
# }



mean_se_points <- function(calpoints,point_vals){
	cat("Now click on Upper SE, followed by the Mean")
	group_points <- locator(2, type="o", col="red", lwd=2)
	group_points_cal <- digitize::Calibrate(group_points, calpoints, point_vals[1], point_vals[2], point_vals[3], point_vals[4])
	group_mean <- group_points_cal$y[2]
	group_se <- group_points_cal$y[1] - group_points_cal$y[2]	
	c(group_mean,group_se,mean(group_points_cal$x))
	}
	
boxplot_points <- function(calpoints,point_vals){
	cat("Now click on Max, Upper Q, Median, Lower Q, and Minimum\nIn that order")
	group_points <- locator(5, type="o", col="red", lwd=2)
	group_points_cal <- digitize::Calibrate(group_points, calpoints, point_vals[1], point_vals[2], point_vals[3], point_vals[4])
	c(group_points_cal[,"y"],mean(group_points_cal$x))
	}




extract_points <- function(file, plot_type=c("mean_se","boxplot","scatterplot")){
	
	#"~/Dropbox/0_postdoc/8_PR repeat/shared/extracted graphs/5_fig2a.png"
	image <- magick::image_read(file)
	plot(image)

	new_image <- graph_rotate(image)
	flush.console()
	cat( "Use your mouse, and the image, 
but careful how you calibrate.
Click IN ORDER: x1, x2, y1, y2 \n
	
    Step 1 ----> Click on x1
  |
  |
  |
  |
  |_______x1__________________
\n
    Step 2 ----> Click on x2
  |
  |
  |
  |
  |____________________x2_____
\n
    Step 3 ----> Click on y1
  |
  |
  |
  y1
  |___________________________
\n
    Step 4 ----> Click on y2
  |
  y2
  |
  |
  |___________________________
"
	 )
	
	calpoints <- locator(4, type="p", col="blue", pch=3, lwd = 2)
	flush.console()
	point_vals <- getVals()
	
	
	if(plot_type %in% c("mean_se","boxplot")){
	
		nMeans <- as.numeric(base::readline("Number of groups: "))
		group_data <- if(plot_type == "mean_se") {as.data.frame(matrix(NA, ncol=4, nrow=nMeans, dimnames=list(NULL, c("id","mean","se","x"))))}else if(plot_type == "boxplot") {as.data.frame(matrix(NA, ncol=7, nrow=nMeans, dimnames=list(NULL, c("id","max","q3","med","q1","min","x"))))}
			
		for(i in 1:nMeans) {
			add_removeQ <- "r"
			while(add_removeQ=="r") {
				group_data[i,1] <- base::readline(paste("Group identifier",i,":"))
				if(plot_type == "mean_se") group_data[i,2:4] <- mean_se_points(calpoints,point_vals)
				if(plot_type == "boxplot") group_data[i,2:7] <- boxplot_points(calpoints,point_vals)
				add_removeQ <- base::readline("Continue or reclick? c/r ")
				while(!add_removeQ  %in% c("c","r")) add_removeQ <- base::readline("Continue or reclick? c/r ")	
			}
		}
	}
	
	
	if(plot_type == "scatterplot"){
		add_removeQ <- "a"
		group_points <- data.frame()
		
		while(add_removeQ!="f"){
			if(add_removeQ=="a"){
						cat(
						    "..............NOW .............",
						    "Click all the data. (Do not hit ESC, close the window or press any mouse key.)",
						    "Once you are done - exit:",
						    " - Windows: right click on the plot area and choose 'Stop'!",
						    " - X11: hit any mouse button other than the left one.",
						    " - quartz/OS X: hit ESC",
						    "If you would like to remove a point, exit, then select remove, \n",
						    "and choose the point. Then choose Add to continue extracting data.",
						    sep = "\n\n"
						  )
				group_points <- rbind(group_points, as.data.frame(locator(type="p", col="red", lwd=2)))}
			if(add_removeQ=="r") {
				remove <- locator(1,type="p", col="green", pch=4, lwd=2)
				x_remove <- which(abs(group_points$x-remove$x) == min(abs(group_points$x-remove$x)))
				y_remove <- which(abs(group_points$y-remove$y) == min(abs(group_points$y-remove$y)))
				if(x_remove==y_remove) {
					points(group_points$x[x_remove],group_points$y[y_remove], col="green", lwd=2)
					group_points <- group_points[-x_remove,]
					}else{cat("Point not identified")
				}
			}
			add_removeQ <- base::readline("Add, remove or finish? a/r/f ")		
		}
	group_data <- digitize::Calibrate(group_points, calpoints, point_vals[1], point_vals[2], point_vals[3], point_vals[4])

	}	
	return(group_data)
}
	




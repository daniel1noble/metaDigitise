#' @title error_to_sd
#' @description Transforms error to standard deviation
#' @param error some form of error
#' @param n Sample Size
#' @param error_type type of error measured
#' @return Returns vector of standard errors
#' @author Joel Pick
#' @export

error_to_sd <- function(error, n, error_type=c("se","CI95","sd",NA)){
	 sd <- ifelse(error_type=="se", se_to_sd(error, n),
			ifelse(error_type=="CI95", CI95_to_sd(error, n),
			ifelse(error_type=="sd", error,
			ifelse(is.na(error_type), NA, NA
			))))
	return(sd)
}


#' @title se_to_sd
#' @description Transforms standard error to standard deviation
#' @param se Standard Error of the mean
#' @param n Sample Size
#' @return Returns vector of standard errors
#' @author Joel Pick
#' @examples se_to_sd(se = 5, n = 10)
#' @export

se_to_sd <- function(se, n) {
	se * sqrt(n)
}


#' @title CI95_to_sd
#' @description Transforms symmetrical confidence interval to standard deviation
#' @param CI Interval difference from the mean
#' @param n Sample Size
#' @return Returns vector of standard deviations
#' @author Joel Pick
#' @examples CI95_to_sd(CI = 2, n = 10)
#' @export

CI95_to_sd <- function(CI,n) {
	CI/1.96 * sqrt(n)
}



#' @title rqm_to_mean
#' @description Calculate the mean from the box plots
#' @param min Minimum value
#' @param LQ Lower 75th quartile
#' @param median Median
#' @param UQ Upper 75th quartile
#' @param max Maximum value
#' @param n Sample size
#' @return Returns vector of mean
#' @author Joel Pick
#' @examples rqm_to_mean(min = 2, LQ = 3, median = 5, UQ = 6, max = 9, n = 30)
#' @export
rqm_to_mean <- function(min,LQ,median,UQ,max,n){
	b <- max
	a <- min
	q3 <- UQ
	q1 <- LQ
	m <- median
	
	##from Wan et al. 2014; equation 10
	Xbar <- (a + 2*q1 + 2*m + 2*q3 + b)/8
	## from Bland 2014;
	#Xbar <- ( (n+3)*(a+b) + 2*(n-1)*(q_1 + m + q_3) )/8n
	return(Xbar)
}

#' @title rqm_to_sd
#' @description Calculate the standard deviation from box plots
#' @param min Minimum value
#' @param LQ Lower 75th quartile
#' @param UQ Upper 75th quartile
#' @param max Maximum value
#' @param n Sample size
#' @return Returns vector of standard deviation
#' @author Joel Pick
#' @examples rqm_to_sd(min = 2, LQ = 3, UQ = 6, max = 9, n = 30)
#' @export
rqm_to_sd <- function(min,LQ,UQ,max,n) {
	b <- max
	a <- min
	q3 <- UQ
	q1 <- LQ
	
	##from Wan et al. 2014; equation 13
	S <- (b-a) / ( 4*stats::qnorm( (n-0.375)/(n+0.25) ) ) + 
		(q3-q1) / ( 4*stats::qnorm( (0.75*n-0.125)/(n+0.25) ) )
		
	return(S)
}

#' @title range_to_sd
#' @description Converts a range to a standard deviation
#' @param min Minimum value
#' @param max Maximum value
#' @param n Sample size
#' @return Returns vector of standard deviation
#' @author Joel Pick
#' @examples range_to_sd(min = 3, max = 8, n = 40)
#' @export

range_to_sd <- function(min,max,n) {
	a <- min
	b <- max
	
	##from Wan et al. 2014; equation 9
	S <- (b-a) / ( 2*stats::qnorm( (n-0.375)/(n+0.25) ) ) 

	return(S)
}

#' @title grandMean
#' @description Pooled mean of a set of group means
#' @param mean Mean
#' @param n Sample size
#' @return Returns vector of pooled mean
#' @author Joel Pick
#' @examples grandMean(mean = 10, n = 30)
#' @export

grandMean <- function(mean,n)	sum(mean*n)/sum(n)


#' @title grandSD
#' @description Pooled standard deviation of a set of groups
#' @param mean Mean
#' @param sd standard deviation
#' @param n Sample size
#' @param equal Logical: Whether to calculate pooled SD assuming groups have the same means (TRUE) or different means (FALSE) 
#' @return Returns vector of pooled mean
#' @author Joel Pick
#' @examples grandSD(mean = 10, sd = 3, n = 40)
#' @export
## for non-overlapping SDs
## https://en.wikipedia.org/w/index.php?title=Standard_deviation&oldid=724302220#Combining_standard_deviations

grandSD <- function(mean,sd,n, equal = FALSE){
	if(equal == FALSE){
	sqrt(
		( sum( (n-1)*sd^2 + n*mean^2 ) - sum(n)*(sum(mean*n)/sum(n))^2 )
		/
		(sum(n) -1)
		)
	}else{
	sqrt( sum( (n-1)*sd^2 ) / sum(n -1) )
	}
}
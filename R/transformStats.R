
#' @title se_to_sd
#' @desciption Transforms standerd error to standard deviation
#' @param se Standard Error of the mean
#' @param n Sample Size
#' @param na.rm Remove NAs
#' @return Returns vector of standard errors
#' @author Joel Pick
#' @example
#' @export
se_to_sd <- function(se, n, na.rm=TRUE) {
	se * sqrt(n)
}


CI95_to_sd <- function(CI95,n) {
	CI95/1.96 * sqrt(n)
}

rqm_to_mean <- function(min,LQ,median,UQ,max){
	b <- max
	a <- min
	q3 <- UQ
	q1 <- LQ
	m <- median
	
	##from Wan et al. 2014; equation 10
	Xbar <- (a + 2*q1 + 2*m + 2*q3 + b)/8
	return(Xbar)
}


rqm_to_sd <- function(min,LQ,UQ,max,n) {
	b <- max
	a <- min
	q3 <- UQ
	q1 <- LQ
	
	##from Wan et al. 2014; equation 13
	S <- (b-a) / ( 4*qnorm( (n-0.375)/(n+0.25) ) ) + 
		(q3-q1) / ( 4*qnorm( (0.75*n-0.125)/(n+0.25) ) )
		
	return(S)
}


range_to_sd <- function(min,max,n) {
	a <- min
	b <- max
	
	##from Wan et al. 2014; equation 9
	S <- (b-a) / ( 2*qnorm( (n-0.375)/(n+0.25) ) ) 

	return(S)
}


grandMean <- function(mean,n)	sum(mean*n)/sum(n)

## for non-overlapping SDs
## https://en.wikipedia.org/w/index.php?title=Standard_deviation&oldid=724302220#Combining_standard_deviations
grandSD <- function(mean,sd,n){
	sqrt(
		( sum( (n-1)*sd^2 + n*mean^2 ) - sum(n)*(sum(mean*n)/sum(n))^2 )
		/
		(sum(n) -1)
		)
	}
	## grandSD <- function(mean,sd,n)	sqrt( sum( (n-1)*sd^2 ) / sum(n -1) )

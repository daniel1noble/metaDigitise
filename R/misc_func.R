#' @title is.wholenumber
#' @param x object to be  tested
#' @param tol tolerance
#' @description Checks whether value is a whole number

is.wholenumber <- function(x, tol = .Machine$double.eps^0.5)  abs(x - round(x)) < tol


#' @title isNumeric
#' @param x character to be tested
#' @description Checks whether a character is a number

isNumeric <- function(x) !suppressWarnings(is.na(as.numeric(x)))


#' @title is.even
#' @param x integer value
#' @description Checks whether a integer is even

is.even <- function(x) x %% 2 == 0



#' @title filename
#' @param x filepath
#' @description extracts filename from filepath

filename <- function(x) {
	y <- strsplit(x,"/")
	sapply(y, function(z) z[length(z)], USE.NAMES = FALSE)
}

#' @title user_options
#' @param question question
#' @param allowed_answers allowed answers
#' @description asks user for option from specified list

user_options <- function(question, allowed_answers) {
	input_bad <- TRUE
	while(input_bad){
		input <- readline(paste(question,"\n"))
		input_bad <- !input %in% allowed_answers
		if(input_bad) cat("\n**** Invalid response ****\n")
	}
	return(input)
}

#' @title user_unique
#' @param question question
#' @param previous_answers allowed answers
#' @description asks user for option from specified list

user_unique <- function(question, previous_answers) {
	input_bad <- TRUE
	while(input_bad){
		input <- readline(paste(question,"\n"))
		input_bad <- input %in% previous_answers
		if(input_bad) cat("\n**** Response must be unique ****\n")
	}
	return(input)
}

#' @title user_numeric
#' @param question question
#' @description asks user for numeric

user_numeric <- function(question) {
	input_bad <- TRUE
	while(input_bad){
    	input <- suppressWarnings(as.numeric(readline(paste(question,"\n"))))
		input_bad <- is.na(input)
		if(input_bad) cat("\n**** Input must be numeric ****\n")
	}
	return(input)
}


#' @title user_count
#' @param question question
#' @description asks user for count

user_count <- function(question) {
	input_bad <- TRUE
	while(input_bad){
		input <- suppressWarnings(as.numeric(readline(paste(question,"\n"))))
		input_bad <- is.na(input)| input<1 | !is.wholenumber(input)
		if(input_bad) cat("\n**** Input must be an integer above 0 ****\n")
	}
	return(input)
}


#' @title user_base
#' @param ... arguments passed to other functions
#' @description asks user for base of logarithm, accept numeric or "e"

user_base <- function(...) {
  input_bad <- TRUE
  while(input_bad){
    input <- readline("To what base? Enter e for LN or a numeric\n")
    input_bad <- !(input == "e" | isNumeric(input) )
    if(input_bad) cat("\n**** Input must be 'e' or numeric ****\n")
  }
  return(input)
}


#' @title ask_variable
#' @param plot_type plot_type
#' @description asks user what variable(s) is depending on plot type

ask_variable <- function(plot_type){
	if(plot_type == "scatterplot"){
		y_variable <- readline("\nWhat is the y variable? \n")
		x_variable <- readline("\nWhat is the x variable? \n")
		variable <- c(y=y_variable,x=x_variable)
	}else if(plot_type == "histogram"){
		variable <- c(readline("\nWhat is the x variable? \n"))
	}else{
		variable <- c(readline("\nWhat is the y variable? \n"))
	}
	return(variable)
}


#' @title cat_matrix
#' @param x vector
#' @param cols number of columns
#' @description prints a vector as a number list of items with a certain number of columns

cat_matrix<- function(x, cols){
	rows <- ceiling(length(x)/cols)
	files_print<- c(paste(1:length(x), x, sep = ". ") ,rep("",rows*cols - length(x)))
	rows_print <- apply(matrix(files_print, nrow=rows, byrow=TRUE),1,paste,collapse = "\t")
	cat(rows_print,sep="\n")
}



#' @title knownN
#' @param plot_type plot type
#' @param processed_data raw_data
#' @param knownN previously entered N
#' @param ... arguments from other calls
#' @description prints a vector as a number list of items with a certain number of columns

knownN <- function(plot_type, processed_data, knownN = NULL,...){
	ids <- 	unique(processed_data$id)
	cat("\nThe estimated samples sizes for each group are:\n\n")
	print(if(plot_type=="histogram") sum(processed_data$frequency) else table(processed_data$id))
	if(is.null(knownN)){
		cat(paste("\nThe known sample size may differ from that in the extracted data\n",ifelse(plot_type=="histogram", "(e.g. with slight error in clicking)","(e.g. if there are overlaying points)") ))
		trueN <- user_options( "\nDo you want to enter a different sample size from that estimated? (y/n) ", c("y","n") )
	}else{
		cat("\nPreviously entered known sample sizes for each group are:\n\n")
		print(knownN)
		if(length(ids)!=length(knownN)){
			cat("\nThe known samples sizes need to be updated.\n\n")
			trueN <- user_options( "\nEnter 'y' to re-enter, or 'n' to use estimated sample sizes (y/n) ", c("y","n") )
		}else{
			trueN <- user_options( "\nEnter 'y' to re-enter, 'c' to continue using entered N, or 'n' to use estimated sample sizes (y/c/n) ", c("y","c","n") )
		}
	}
	if(trueN=="y"){
		knownN = NULL
		for (i in ids) knownN[i]  <- user_count(paste("Group \"", i,"\": Enter sample size "))
	}else if(trueN=="c"){
		knownN <- knownN
	}else{
		knownN <- NULL
	}
	return(knownN)
}







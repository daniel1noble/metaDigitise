#' @title is.wholenumber
#' @param x object to be  tested
#' @param tol tolerance
#' @description Checks whether value is a whole number

is.wholenumber <- function(x, tol = .Machine$double.eps^0.5)  abs(x - round(x)) < tol


#' @title isNumeric
#' @param x character to be tested
#' @description Checks whether a character is a number

isNumeric <- function(x) !suppressWarnings(is.na(as.numeric(x)))


#' @title filename
#' @param x filepath
#' @description extracts filename from filepath

filename <- function(x) {
	y <- strsplit(x,"/")[[1]]
	return(y[length(y)])
}


#' @title user_options
#' @param question question
#' @param allowed_answers allowed answers
#' @description asks user for option from specified list

user_options <- function(question, allowed_answers) {
	input_bad <- TRUE
	while(input_bad){
		input <- readline(question)
		input_bad <- !input %in% allowed_answers
		if(input_bad) cat("\n**** Invalid response ****\n")
	}
	return(input)
}

#' @title user_unique
#' @param question question
#' @param allowed_answers allowed answers
#' @description asks user for option from specified list

user_unique <- function(question, previous_answers) {
	input_bad <- TRUE
	while(input_bad){
		input <- readline(question)
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
    	input <- suppressWarnings(as.numeric(readline(question)))
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
		input <- suppressWarnings(as.numeric(readline(question)))
		input_bad <- is.na(input)| input<1 | !is.wholenumber(input)
		if(input_bad) cat("\n**** Input must be an integer above 0 ****\n")
	}
	return(input)
}



#' @title ask_variable
#' @param plot_type plot_type
#' @description asks user what variable(s) is depending on plot type

ask_variable <- function(plot_type){
	if(plot_type == "scatterplot"){
		y_variable <- readline("\nWhat is the y variable? ")
		x_variable <- readline("\nWhat is the x variable? ")
		variable <- c(y=y_variable,x=x_variable)
	}else{
		variable <- c(y=readline("\nWhat is the variable? "))
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

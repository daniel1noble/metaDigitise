#' @title is.wholenumber
#' @param x object to be  tested
#' @param tol tolerance
#' @description Checks whether value is a whole number

is.wholenumber <- function(x, tol = .Machine$double.eps^0.5)  abs(x - round(x)) < tol


#' @title isNumeric
#' @param x character to be tested
#' @description Checks whether a character is a number

isNumeric <- function(x) !suppressWarnings(is.na(as.numeric(x)))

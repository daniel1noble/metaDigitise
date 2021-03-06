% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/transformStats.R
\name{error_to_sd}
\alias{error_to_sd}
\title{error_to_sd}
\usage{
error_to_sd(error, n, error_type = c("se", "CI95", "sd", NA))
}
\arguments{
\item{error}{some form of error}

\item{n}{Sample Size}

\item{error_type}{type of error measured}
}
\value{
Returns vector of standard errors
}
\description{
Transforms error to standard deviation
}
\author{
Joel Pick
}

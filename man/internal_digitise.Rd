% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metaDigitise_functions.R
\name{internal_digitise}
\alias{internal_digitise}
\title{internal_digitise}
\usage{
internal_digitise(image_file, plot_type = NULL, cex)
}
\arguments{
\item{image_file}{Image file}

\item{plot_type}{Type of plot from "mean_error","boxplot","scatterplot" or"histogram". Function will prompt if not entered by user.}

\item{cex}{point size for replotting}
}
\value{
List of user inputs and transformed data from digitisation
}
\description{
Extracts points from a single figure and processes data
}
\author{
Joel Pick
}

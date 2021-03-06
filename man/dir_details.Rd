% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metaDigitise.R
\name{dir_details}
\alias{dir_details}
\title{dir_details}
\usage{
dir_details(dir)
}
\arguments{
\item{dir}{the path name to the directory / folder where the files are located}
}
\description{
Function will gather important directory details about calibration files and figures needed for processing
}
\examples{
 \donttest{
# temporary directory
tmp_dir <- tempdir()

setup_calibration_dir(paste0(tmp_dir, "/"))

# Simulate data
set.seed(103)
x <- rnorm(20,0,1)
y <- rnorm(20,0,1)
means <- c(mean(x),mean(y))
ses <- c(sd(x)/sqrt(length(x))*1.96, sd(y)/sqrt(length(y))*1.96)

#Generate mock figures
png(filename = paste0(tmp_dir,"/mean_error.png"), width = 480, height = 480)
plot(means, ylim = c(min(means-ses)-0.1,max(means+ses)+0.1), xlim=c(0.5,2.5), 
xaxt="n", pch=19, cex=2, ylab="Variable +/- SE", xlab="Treatment", main="Mean Error")
arrows(1:length(means),means+ses, 1:length(means), means-ses, code=3, angle=90, length=0.1)
axis(1,1:length(means),names(means))
dev.off()
png(filename = paste0(tmp_dir, "/boxplot.png"), width = 480, height = 480)
boxplot(x,y, main="Boxplot")
dev.off()
png(filename = paste0(tmp_dir, "/histogram.png"),width = 480, height = 480)
hist(c(x,y), xlab= "variable", main="Histogram")
dev.off()
png(filename = paste0(tmp_dir, "/scatterplot.png"), width = 480, height = 480)
plot(x,y, main="Scatterplot")
dev.off()

#Obtain details on directory structure that are used for metaDigitise
data <- dir_details(tmp_dir)
}
}
\author{
Daniel Noble - daniel.wa.noble@gmail.com
}

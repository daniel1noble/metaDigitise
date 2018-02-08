rm(list=ls())

setwd("~/Dropbox/0_postdoc/10_metaDigitise/docs/reproduction_script")

## extracted data from 14 digitisers
data <- read.csv("interobserver_data.csv")

## generated data for figures that were given out to test metaDigitise
	set.seed(86)
	x <- rnorm(20, 3, 1)
	grp <- rep(c(1,0), each = 10)
	y <- rnorm(20, 4 + 2*grp + 1.2*x + -0.5*(x*grp), 1)

	gen_dat <- data.frame(dat=c(x,y), axis=rep(c("x","y"),each=20), group=rep(grp,2))

	gen_means <- rbind(aggregate(dat~group+axis,gen_dat,mean), cbind(group="all", aggregate(dat~axis,gen_dat,mean)))
	colnames(gen_means)[3]<-"gen_mean"
	gen_sd <- rbind(aggregate(dat~group+axis,gen_dat,sd), cbind(group="all", aggregate(dat~axis,gen_dat,sd)))
	colnames(gen_sd)[3]<-"gen_sd"

	gen_r <- data.frame()
	for(i in c(0,1))gen_r <-rbind(gen_r, data.frame(group=i, gen_r=cor(subset(gen_dat,axis=="x" & group==i)$dat,subset(gen_dat,axis=="y" & group==i)$dat)))
	
	
	
## put generated and extracted data together
	merge_dat <- merge(data,merge(gen_means, gen_sd))
	head(merge_dat)
	
	merge_dat$mean_dev <- with(merge_dat, (mean-gen_mean)/mean)
	merge_dat$sd_dev <- with(merge_dat, (sd-gen_sd)/sd)
	
## correlation coefficient data	
	r_dat <- merge(subset(merge_dat, axis=="x" & !is.na(r)),gen_r)
	r_dat$r_dev <- with(r_dat, (r-gen_r))

	
	
# Models
library(lme4)
library(rptR)

 ########## Mean #########

  # Estimate repeatability and likelihood ratio test
	rptGaussian(mean_dev ~  1 + (1|id), grname = "id", data = merge_dat)


 ########## Standard Deviation #########

  # Estimate repeatability and likelihood ratio test
	rptGaussian(sd_dev ~  1 + (1|id), grname = "id", data = merge_dat)



 ########## Pearson's correlation coefficient #########

  # Estimate repeatability and likelihood ratio test
	rptGaussian(r_dev ~  1 + (1|id), grname = "id", data = r_dat)

	

## bias
	bias <- c(
		mean(merge_dat$mean_dev),
		mean(merge_dat$sd_dev),
		mean(r_dat$r_dev)
		)
	
	mean(bias)

## absolute deviation
	abs_dev <- c(
		mean(abs(merge_dat$mean_dev)),
		mean(abs(merge_dat$sd_dev)),
		mean(abs(r_dat$r_dev))
		)

	mean(abs_dev)


## bias in SD calculation by plot type
round(with(merge_dat, tapply(abs(sd_dev), plot_type, mean))*100,3)
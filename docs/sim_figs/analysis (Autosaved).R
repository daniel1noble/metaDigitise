
rm(list=ls())
#Grab all the files that are relevant
	
	setwd("~/Dropbox/sim_figs")

	files <- list.files(".", recursive = TRUE, pattern = ".csv")
	paths <- paste0("./", files)
	names <- gsub(".+/", "", x = files)

# Import all the data

	datalist <- lapply(paths, function(x) cbind(read.csv(x, stringsAsFactors=FALSE), id=gsub(".+/", "", x = x)))
#	names(datalist) <- names

# Change list to data and get the unique plot names for analysis 
#ldply
	data <- do.call(rbind,datalist)
	rownames(data) <- 1:nrow(data)
	data$axis <- ifelse(data$axis=="",substr(data$filename,nchar(data$filename)-4,nchar(data$filename)-4),data$axis)
	data$group <- ifelse(is.na(data$group), "all",data$group)

head(data)

#	data$plot <- gsub("[0-9]+_", "", data$filename)
#	data$dat <- gsub("[0-9][0-9][0-9]", "", data$plot)


##generated data
	set.seed(86)
	x <- rnorm(20, 3, 1)
	grp <- rep(c(1,0), each = 10)
	y <- rnorm(20, 4 + 2*grp + 1.2*x + -0.5*(x*grp), 1)

	gen_dat <- data.frame(dat=c(x,y), axis=rep(c("x","y"),each=20), group=rep(grp,2))

	gen_means <- rbind(aggregate(dat~group+axis,gen_dat,mean), cbind(group="all", aggregate(dat~axis,gen_dat,mean)))
	colnames(gen_means)[3]<-"gen_mean"
	gen_sd <- rbind(aggregate(dat~group+axis,gen_dat,sd), cbind(group="all", aggregate(dat~axis,gen_dat,sd)))
	colnames(gen_sd)[3]<-"gen_sd"

#gen_r <- 

	merge_dat <- merge(merge(data,gen_means), gen_sd)


par(mfcol=c(2,4))
for(i in unique(merge_dat$plot_type)) {
	within(subset(merge_dat, plot_type==i),{ 
		hist((mean-gen_mean)/mean, col="grey", main=paste("mean -",i), breaks=50)
		hist((sd-gen_sd)/mean, col="grey", main=paste("sd -",i), breaks=50)
	})
	}

hist(data$r, breaks=100)

# Model
library(lme4)

  # mean
	modX <- lmer(mean ~ plot_type*axis*group + (1|id), REML = FALSE, data = data)
	summary(modX)

	modX2 <- lm(mean ~ plot_type*axis*group, data = data)

	anova(modX, modX2)

	# SD
	modSD <- lmer(sd ~  (1|id), REML = FALSE, data = data)
	summary(modSD)

	modSD2 <- lm(sd ~ 1, data = data)
	anova(modSD, modSD2)

	# r
	modr <- lmer(r ~ group + (1|id), REML = FALSE, data = data)
	summary(modr)

	modr2 <- lm(r ~ 1, data = data)
	anova(modr, modr2)

	# Check out BLUPS
	coef(modr)
	ranef(modr)
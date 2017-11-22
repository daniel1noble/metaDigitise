
rm(list=ls())
#Grab all the files that are relevant
	files <- list.files("./docs/sim_figs/", recursive = TRUE, pattern = ".csv")
	paths <- paste0("./docs/sim_figs/", files)
	names <- gsub(".+/", "", x = files)

# Import all the data
	datalist <- lapply(paths, function(x) read.csv(x))
	names(datalist) <- names

# Change list to data and get the unique plot names for analysis 
	data <- ldply(datalist)
	data$plot <- gsub("[0-9]+_", "", data$filename)
	data$dat <- gsub("[0-9][0-9][0-9]", "", data$plot)

# Model
  # mean
	modX <- lmer(mean ~ dat + (1|.id), REML = FALSE, data = data)
	summary(modX)

	modX2 <- lm(mean ~ dat, data = data)

	anova(modX, modX2)

	# SD
	modSD <- lmer(sd ~ dat + (1|.id), REML = FALSE, data = data)
	summary(modSD)

	modSD2 <- lm(sd ~ dat, data = data)
	anova(modSD, modSD2)

	# r
	modr <- lmer(r ~ 1 + (1|.id), REML = FALSE, data = data)
	summary(modr)

	modr2 <- lm(r ~ 1, data = data)
	anova(modr, modr2)

	# Check out BLUPS
	coef(modr)
	ranef(modr)
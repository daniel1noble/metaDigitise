
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
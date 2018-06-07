context("Check import_digitise.R functions...")

mock_object1 <- list(
	image_file = "./image1.png",
	flip=FALSE,
	rotate=0,
	plot_type="mean_error",
	variable="y",
	calpoints = data.frame(x=c(0,0),y=c(0,100)), 
	point_vals = c(1,2), 
	entered_N=TRUE,
	raw_data = data.frame(id=rep("control",2), x=c(60,60), y=c(75,50), n=rep(20,2)),
	knownN = NULL,
	error_type="sd",
	processed_data=data.frame(id=as.factor("control"),mean=1.5, error=0.25, n=20, variable="y", stringsAsFactors = FALSE)	
	)

class(mock_object1) <- 'metaDigitise'

mock_object2 <- list(
	image_file = "./image2.png",
	flip=FALSE,
	rotate=0,
	plot_type="mean_error",
	variable="y",
	calpoints = data.frame(x=c(0,0),y=c(0,100)), 
	point_vals = c(1,2), 
	entered_N=TRUE,
	raw_data = data.frame(id=rep("control",2), x=c(60,60), y=c(75,50), n=rep(20,2)),
	knownN = NULL,
	error_type="sd",
	processed_data=data.frame(id=as.factor("control"),mean=4, error=2, n=20, variable="y", stringsAsFactors = FALSE)	
	)

class(mock_object2) <- 'metaDigitise'

list <- list(mock_object1=mock_object1, mock_object2=mock_object2)
tmp_dir_no_slash <- tempdir()
tmp_dir <- paste0(tmp_dir_no_slash, "/")
dir.create(paste0(tmp_dir, "caldat/"))

list.files(paste0(tmp_dir, "caldat/"))
list.files(tmp_dir)

saveRDS(mock_object1, file = paste0(tmp_dir, "caldat/", "mock_object1"))
saveRDS(mock_object2, file = paste0(tmp_dir, "caldat/", "mock_object2"))

doneCalFiles <- paste0(tmp_dir, "caldat/", list.files(paste0(tmp_dir, "/caldat/")))
names <- list("mock_object1", "mock_object2")
	

testthat::test_that("Checking load_metaDigitise works as expected..", {
	loaded <- load_metaDigitise(doneCalFiles, names)
	summaries <- lapply(loaded, function(x) summary(x))
	testthat::expect_equal(summaries$mock_object1$mean, 1.5, info="Object 1 loaded and matches mean..")
	testthat::expect_equal(summaries$mock_object2$mean, 4, info="Object 2 loaded and matches mean..")
})

testthat::test_that("Checking import_metaDigitise works as expected..", {
	summaries <- import_metaDigitise(tmp_dir, summary=TRUE)
	testthat::expect_equal(summaries$mean[1], 1.5, info="Object 1 loaded and matches mean after import_metaDigitis..")
	testthat::expect_equal(summaries$mean[2], 4, info="Object 2 loaded and matches mean after import_metaDigitis..")
})




testthat::test_that("Checking getExtracted works as expected..", {
	
	testthat::expect_equal(getExtracted(tmp_dir, summary=TRUE), 
		rbind(summary(mock_object1),summary(mock_object2)), 
		info="Problem with summary=TRUE")
	
	testthat::expect_equal(getExtracted(tmp_dir_no_slash, summary=TRUE), 
		rbind(summary(mock_object1),summary(mock_object2)), 
		info="Problem with directory input")
	
	testthat::expect_equal(getExtracted(tmp_dir, summary=FALSE)[[1]][[1]], 
		mock_object1$processed_data, 
		info="Problem with summary=FALSE")

	testthat::expect_equal(getExtracted(tmp_dir_no_slash, summary=FALSE)[[1]][[1]], 
		mock_object1$processed_data, 
		info="Problem with directory input")

})



test_that("Checking ordered_lists works as expected..", {
	objects <- load_metaDigitise(doneCalFiles, names)
	plot_type <- lapply(objects, function(x) x$plot_type)

	list <- order_lists(objects, plot_type)

	expect_equal(names(list), "mean_error", info = "Checked that plot type names are set up correct in ordered lists")
})

user_options_tester_func <- function(...) {
	with_mock(
		readline = function(question) "a",
		user_options (...)
		)
}

test_that("Checking import_menu works as expected..", {
	with_mock(
			menu = function(...) 1,
			tmp <- import_menu(tmp_dir, summary = TRUE), 
			expect_equal(tmp$mean[1], 1.5, info="Object 1 loaded and matches mean after import_menu..."),
			expect_equal(tmp$mean[2], 4, info="Object 2 loaded and matches mean after import_menu...")
	)
})
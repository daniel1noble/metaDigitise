context("Check various metaDigitise.R functions...")

testthat::test_that("Checking setup_calibration_dir works as expected..", {
	dir <- paste0(tempdir(), "/")
	setup_calibration_dir(dir)
	testthat::expect_equal(list.files(dir)[grep("caldat",list.files(dir))], "caldat", info = "caldat setup correctly")
})

testthat::test_that("Checking dir_details works as expected..", {
	dir <- paste0(tempdir(), "/")
	setup_calibration_dir(dir)
	list <- dir_details(dir)

	testthat::expect_equal(length(list$images), 0, info = "No images in directory as expected..")
	testthat::expect_equal(list$paths, dir, info = "Directory in paths matches..")
	testthat::expect_equal(list$cal_dir, paste0(dir, "caldat/"), info = "Directory in paths to cal_dat folder matches as expected..")

})

testthat::test_that("Checking specify_type works as expected..", {
	testthat::with_mock(
		readline = function(...) "m",
		testthat::expect_equal(specify_type(), "mean_error", info = "specify_type not working correctly does not match mean_error")
	)

	testthat::with_mock(
		readline = function(...) "s",
		testthat::expect_equal(specify_type(), "scatterplot", info = "specify_type not working correctly does not match scatterplot")
	)

	testthat::with_mock(
		readline = function(...) "b",
		testthat::expect_equal(specify_type(), "boxplot", info = "specify_type not working correctly does not match boxplot")
	)
	
})


mock_object <- list(
	image_file = "./image.png",
	flip=FALSE,
	rotate=0,
	plot_type="mean_error",
	variable="y",
	calpoints = data.frame(x=c(0,0),y=c(0,100), stringsAsFactors = TRUE), 
	point_vals = c(1,2), 
	entered_N=TRUE,
	raw_data = data.frame(id=rep("control",2), x=c(60,60), y=c(75,50), n=rep(20,2), stringsAsFactors = TRUE),
	knownN = NULL,
	error_type="sd",
	processed_data=data.frame(id=as.factor("control"),mean=1.5, error=0.25, n=20, variable="y", stringsAsFactors = FALSE)	
	)

class(mock_object) <- 'metaDigitise'


testthat::test_that("Checking extract_digitised works as expected..", {
	
	ob_sum <- extract_digitised(list(mock_object), summary = TRUE)
	ob_raw <- extract_digitised(list(mock_object), summary = FALSE)

	testthat::expect_equal(class(ob_sum), "data.frame", info = "Summary object is indeed a data frame..")
	testthat::expect_equal(ob_sum$mean, 1.5, info = "Summary object mean matches..")
	testthat::expect_equal(class(ob_raw), "list", info = "Raw object is indeed a list..")
	testthat::expect_equal(names(ob_raw), "image.png", info = "Raw object name is correct..")
	testthat::expect_equal(names(ob_raw), "image.png", info = "Raw object name is correct..")
	testthat::expect_equal(ob_raw[[1]]$mean, 1.5, info = "List object mean matches..")

})

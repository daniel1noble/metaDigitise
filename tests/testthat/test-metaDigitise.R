context("Check various metaDigitise.R functions...")

test_that("Checking setup_calibration_dir works as expected..", {
	dir <- paste0(tempdir(), "/")
	setup_calibration_dir(dir)
	expect_equal(list.files(dir)[grep("caldat",list.files(dir))], "caldat", info = "caldat setup correctly")
})

test_that("Checking dir_details works as expected..", {
	dir <- paste0(tempdir(), "/")
	setup_calibration_dir(dir)
	list <- dir_details(dir)

	expect_equal(length(list$images), 0, info = "No images in directory as expected..")
	expect_equal(list$paths, dir, info = "Directory in paths matches..")
	expect_equal(list$cal_dir, paste0(dir, "caldat/"), info = "Directory in paths to cal_dat folder matches as expected..")

})

test_that("Checking specify_type works as expected..", {
	with_mock(
		readline = function(...) "m",
		expect_equal(specify_type(), "mean_error", info = "specify_type not working correctly does not match mean_error")
	)

	with_mock(
		readline = function(...) "s",
		expect_equal(specify_type(), "scatterplot", info = "specify_type not working correctly does not match scatterplot")
	)

	with_mock(
		readline = function(...) "b",
		expect_equal(metaDigitise::specify_type(), "boxplot", info = "specify_type not working correctly does not match boxplot")
	)
	
})


mock_object <- list(
	image_file = "./image.png",
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

class(mock_object) <- 'metaDigitise'


test_that("Checking extract_digitised works as expected..", {
	
	ob_sum <- extract_digitised(list(mock_object), summary = TRUE)
	ob_raw <- extract_digitised(list(mock_object), summary = FALSE)

	expect_equal(class(ob_sum), "data.frame", info = "Summary object is indeed a data frame..")
	expect_equal(ob_sum$mean, 1.5, info = "Summary object mean matches..")
	expect_equal(class(ob_raw), "list", info = "Raw object is indeed a list..")
	expect_equal(names(ob_raw), "image.png", info = "Raw object name is correct..")
	expect_equal(names(ob_raw), "image.png", info = "Raw object name is correct..")
	expect_equal(ob_raw[[1]]$mean, 1.5, info = "List object mean matches..")

})

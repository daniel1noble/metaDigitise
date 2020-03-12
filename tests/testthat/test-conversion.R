
context("Check conversions...")

testthat::test_that("Checking calibrate..", {
	testthat::expect_equal(
		calibrate(raw_data = data.frame(x=50,y=50, stringsAsFactors = TRUE), calpoints = data.frame(x=c(0,0,0,100),y=c(0,100,0,0), stringsAsFactors = TRUE), point_vals = c(1,2,3,4), log_axes="n"),
		data.frame(x=3.5,y=1.5, stringsAsFactors = TRUE), 
		info = "calibrate failed")
	
	testthat::expect_equal(
		calibrate(raw_data = data.frame(x=50,y=50, stringsAsFactors = TRUE), calpoints = data.frame(x=c(0,0),y=c(0,100), stringsAsFactors = TRUE), point_vals = c(1,2), log_axes="n"), 
		data.frame(x=50,y=1.5, stringsAsFactors = TRUE), 
		info = "calibrate failed")

})


testthat::test_that("Checking convert_histogram_data..", {
	expect_equal(
		convert_histogram_data(cal_data = data.frame(id=rep("control",2),bar=c(1,1), x=c(1,3), y=c(5,5), stringsAsFactors = TRUE)), 
		data.frame(id="control", midpoints=2, frequency=5, stringsAsFactors = TRUE),
		info = "convert_histogram_data failed")
})


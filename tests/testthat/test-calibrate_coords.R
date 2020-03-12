
context("Check calibrate_coords...")

testthat::test_that("Checking cal_coords..", {
		
	testthat::with_mock(
		`metaDigitise::locator_mD` = mockery::mock(list(x=c(0,0),y=c(0,100)), list(x=c(0,100),y=c(0,0))),
		expect_equal(
			cal_coords(plot_type="scatterplot",cex=1), 
			data.frame(x=c(0,0,0,100),y=c(0,100,0,0), stringsAsFactors = TRUE), 
			info = "cal_coords failed"
		)
	)

	testthat::with_mock(
		`metaDigitise::locator_mD` = mockery::mock(list(x=c(0,0),y=c(0,100)), list(x=c(0,100),y=c(0,0))),
		expect_equal(
			cal_coords(plot_type="mean_error",cex=1), 
			data.frame(x=c(0,0),y=c(0,100), stringsAsFactors = TRUE), 
			info = "cal_coords failed"
		)
	)
})


	
testthat::test_that("Checking getVals..", {
		
	testthat::with_mock(
		`metaDigitise::user_numeric` = mockery::mock(1,2,3,4),
		testthat::expect_equal(
			getVals(calpoints=data.frame(x=c(0,0,0,100),y=c(0,100,0,0), stringsAsFactors = TRUE)), 
			c(y1=1,y2=2,x1=3,x2=4), 
			info = "getVals failed"
		)
	)

	testthat::with_mock(
		`metaDigitise::user_numeric` = mockery::mock(1,2,3,4),
		testthat::expect_equal(
			getVals(calpoints=data.frame(x=c(0,0),y=c(0,100), stringsAsFactors = TRUE)), 
			c(y1=1,y2=2), 
			info = "getVals failed"
		)
	)
})



testthat::test_that("Checking user_calibrate..", {
	testthat::with_mock(
		`metaDigitise::internal_redraw` = function(...) "",
		`metaDigitise::print_cal_instructions` = function(...) "",
		`metaDigitise::cal_coords` = function(...) data.frame(x=c(0,0,0,100),y=c(0,100,0,0), stringsAsFactors = TRUE),
		`metaDigitise::getVals` = function(...) c(y1=1,y2=2,x1=3,x2=4),
		`metaDigitise::logAxes` = function(...) c(axes="n"),
		readline = function(...) "n",
		testthat::expect_equal(
			user_calibrate(object=list(plot_type="scatterplot")),
			list(calpoints=data.frame(x=c(0,0,0,100),y=c(0,100,0,0), stringsAsFactors = TRUE), point_vals=c(y1=1,y2=2,x1=3,x2=4), log_axes=c(axes="n")), 
			info = "user_calibrate failed"
		)
	)
})


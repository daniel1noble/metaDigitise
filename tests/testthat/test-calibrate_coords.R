
context("Check calibrate_coords...")

test_that("Checking cal_coords..", {
		
	with_mock(
		locator = mock(list(x=c(0,0),y=c(0,100)), list(x=c(0,100),y=c(0,0))),
		expect_equal(
			cal_coords(plot_type="scatterplot"), 
			data.frame(x=c(0,0,0,100),y=c(0,100,0,0)), 
			info = "cal_coords failed"
		)
	)

	with_mock(
		locator = mock(list(x=c(0,0),y=c(0,100)), list(x=c(0,100),y=c(0,0))),
		expect_equal(
			cal_coords(plot_type="mean_error"), 
			data.frame(x=c(0,0),y=c(0,100)), 
			info = "cal_coords failed"
		)
	)
})
	

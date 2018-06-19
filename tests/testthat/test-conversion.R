
context("Check conversions...")

testthat::test_that("Checking calibrate..", {
	testthat::expect_equal(
		calibrate(raw_data = data.frame(x=50,y=50), calpoints = data.frame(x=c(0,0,0,100),y=c(0,100,0,0)), point_vals = c(1,2,3,4), log_axes="n"), 
		data.frame(x=3.5,y=1.5), 
		info = "calibrate failed")
	
	testthat::expect_equal(
		calibrate(raw_data = data.frame(x=50,y=50), calpoints = data.frame(x=c(0,0),y=c(0,100)), point_vals = c(1,2), log_axes="n"), 
		data.frame(x=50,y=1.5), 
		info = "calibrate failed")

})


testthat::test_that("Checking convert_group_data..", {
	testthat::expect_equal( 
		convert_group_data( cal_data = data.frame(id=rep("control",2), x=c(1,1), y=c(7,5), n=rep(20,2)), plot_type = "mean_error"), 
		data.frame(id="control", mean=5, error=2, n=20), 
		info = "mean_error failed")
	
	testthat::expect_equal(
		convert_group_data(cal_data = data.frame(id=rep("control",5), x=c(1,1,1,1,1), y=c(7,5,4,3,1), n=rep(20,5)), plot_type = "boxplot"), 
		data.frame(id="control", max=7, q3=5, med=4, q1=3, min=1, n=20), 
		info = "boxplot failed")
})


testthat::test_that("Checking convert_histogram_data..", {
	expect_equal(
		convert_histogram_data(cal_data = data.frame(id=rep("control",2),bar=c(1,1), x=c(1,3), y=c(5,5))), 
		data.frame(id="control", midpoints=2, frequency=5),
		info = "convert_histogram_data failed")
})


testthat::test_that("Checking process_data..", {
	testthat::expect_equal(
		process_data(object=list(plot_type="mean_error", variable="y", calpoints = data.frame(x=c(0,0),y=c(0,100)), point_vals = c(1,2), raw_data = data.frame(id=rep("control",2), x=c(60,60), y=c(75,50), n=rep(20,2)), log_axes="n")), 
		data.frame(id=as.factor("control"),mean=1.5, error=0.25, n=20, variable="y", stringsAsFactors = FALSE), 
		info = "process_data failed")

	testthat::expect_equal(
		process_data(object=list(plot_type="scatterplot", variable=c(x="x",y="y"), calpoints = data.frame(x=c(0,0,0,100),y=c(0,100,0,0)),point_vals = c(1,3,2,4), raw_data=data.frame(id=1,x=c(25,75),y=c(50,50)), log_axes="n")), 
		data.frame(id=1, x=c(2.5,3.5), y=c(2,2), y_variable="y", x_variable="x", stringsAsFactors = FALSE), 
		info = "process_data failed")

	testthat::expect_equal(
		process_data(object=list(plot_type="histogram", variable="y", calpoints = data.frame(x=c(0,0,0,100),y=c(0,100,0,0)),point_vals = c(1,3,2,4), raw_data=data.frame(id=rep("control",2), bar=1,x=c(25,75),y=c(50,50)), log_axes="n")), 
		data.frame(id=as.factor("control"), midpoints=3, frequency=2, variable="y", stringsAsFactors = FALSE), 
		info = "process_data failed")
})

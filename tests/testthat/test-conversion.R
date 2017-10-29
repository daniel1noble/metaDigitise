
context("Check conversions...")

test_that("Checking calibrate..", {
	expect_equal(
		calibrate(
			raw_data = data.frame(x=50,y=50), 
			calpoints = data.frame(x=c(0,0,0,100),y=c(0,100,0,0)), 
			point_vals = c(1,2,3,4)), 
		data.frame(x=3.5,y=1.5), info = "calibrate failed")
})


test_that("Checking convert_group_data..", {
	expect_equal(
		convert_group_data(
			cal_data = data.frame(id=c("control","control"), x=c(1,1), y=c(7,5), n=rep(20,2)),
			plot_type = "mean_error"
		), 
		data.frame(id="control", mean=5, error=2, n=20), info = "convert_group_data failed")
})

test_that("Checking convert_histogram_data..", {
	expect_equal(
		convert_histogram_data(
			cal_data = data.frame(bar=c(1,1), x=c(1,3), y=c(5,5))
		), 
		data.frame(midpoints=2, frequency=5), info = "convert_histogram_data failed")
})


# test_that("Checking process_data..", {
# 	expect_equal(
# 		process_data(
# 			object=list(plot_type="histogram", variable="y", calpoints = data.frame(x=c(0,0,0,100),y=c(0,100,0,0)),point_vals = c(1,3,2,4), raw_data=data.frame(bar=1,x=c(25,75),y=c(50,50)))
# 		), 
# 		data.frame(midpoints=3, frequency=2, variable="y")
# , info = "process_data failed")
# })



#


context("Check metaDigitise functions...")


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

test_that("Checking summary.metaDigitise..", {
	expect_equal(
		summary.metaDigitise(mock_object),
		data.frame(
			filename=as.factor("image.png"), group_id=as.factor("control"), variable=as.factor("y"), mean=1.5, sd=0.25, n=20, r=NA, plot_type="mean_error", stringsAsFactors = FALSE)
	)
})
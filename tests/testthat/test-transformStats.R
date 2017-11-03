
context("Check conversions...")

test_that("Checking se_to_sd..", {
	expect_equal(se_to_sd(se = 5, n = 20), 22.36068, info = "se to sd failed")
})

test_that("Checking CI95_to_sd...", {
	expect_equal(CI95_to_sd(5, 20), 11.40851, info = "CI to sd failed")
})

test_that("Checking rqm_to_mean...", {
	expect_equal(round(rqm_to_mean(2,3,5,7,10), digits = 2), 5.25, info = "rqm_to_mean failed")
})

test_that("Checking rqm_to_sd...", {
	expect_equal(round(rqm_to_sd(3, 5, 7, 10, 30), digits = 2), 1.64, info = "rqm_to_sd failed")
})

test_that("Checking range_to_sd...", {
	expect_equal(round(range_to_sd(3, 10, 8), digits = 2), 2.44, info = "range_to_sd failed")
})

test_that("Checking grandMean...", {
	expect_equal(grandMean(mean=c(3,5), n=c(10, 10)), 4, info = "grandMean failed")
})

test_that("Checking grandSD...", {
	expect_equal(
		grandSD(mean=c(5,5), sd=c(2,2), n=c(1000, 1000), equal=TRUE), 
		2, 
		info = "grandSD failed")
	expect_equal(
		round(grandSD(mean=c(5,5), sd=c(2,2), n=c(1000, 1000), equal=FALSE),2),
		2, 
		info = "grandSD failed")
})



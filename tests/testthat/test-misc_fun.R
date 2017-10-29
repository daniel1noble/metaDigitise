
context("Check misc functions...")

test_that("Checking is.wholenumber..", {
	expect_equal(
		is.wholenumber(x=1), 
		TRUE, info = "is.wholenumber failed")
})

test_that("Checking isNumeric..", {
	expect_equal(
		isNumeric(x=1), 
		TRUE, info = "isNumeric failed")
})

test_that("Checking filename..", {
	expect_equal(
		filename(x="~/Dropbox/0_postdoc/10_metaDigitise/example_figs/5_fig2a.png"), 
		"5_fig2a.png", info = "filename failed")
})

# test_that("Checking user_options..", {
# 	expect_equal(
# 		user_options(x="~/Dropbox/0_postdoc/10_metaDigitise/example_figs/5_fig2a.png"), 
# 		"5_fig2a.png", info = "user_options failed")
# })
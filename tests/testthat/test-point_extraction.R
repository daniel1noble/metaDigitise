context("Check point_extraction...")


point_extraction_tester_func <- function(...) {
	with_mock(
		MB_extract = function(...) 1,
		group_scatter_extract = function(...) 2,
		histogram_extract = function(...) 3,
		point_extraction (...)
		)
}

test_that("Checking point_extraction..", {
	expect_equal(
 		point_extraction_tester_func(object=list(plot_type="mean_error")), 
		1,
		info = "user_options failed")

	expect_equal(
 		point_extraction_tester_func(object=list(plot_type="scatterplot")), 
		2,
		info = "user_options failed")

	expect_equal(
 		point_extraction_tester_func(object=list(plot_type="histogram")), 
		3,
		info = "user_options failed")
})
 

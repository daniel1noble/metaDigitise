context("Check point_extraction...")




testthat::test_that("Checking point_extraction..", {

point_extraction_tester_func <- function(object,...) {
	testthat::with_mock(
		`metaDigitise::MB_extract` = function(...) 1,
		`metaDigitise::group_scatter_extract` = function(...) 2,
		`metaDigitise::histogram_extract` = function(...) 3,
		point_extraction (object)
		)
}

	testthat::expect_equal(
 		point_extraction_tester_func(object=list(plot_type="mean_error")), 
		1,
		info = "point_extraction failed")

	testthat::expect_equal(
 		point_extraction_tester_func(object=list(plot_type="scatterplot")), 
		2,
		info = "point_extraction failed")

	testthat::expect_equal(
 		point_extraction_tester_func(object=list(plot_type="histogram")), 
		3,
		info = "point_extraction failed")
})
 

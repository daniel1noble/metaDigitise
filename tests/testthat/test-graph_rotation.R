
context("Check graph_rotation...")


testthat::test_that("Checking user_rotate_graph..", {
	testthat::with_mock(
		`metaDigitise::internal_redraw` = function(...){},
		readline = mockery::mock("f","r","c"),
		locator = function(...) list(x=c(1,2), y=c(1,2)),
		testthat::evaluate_promise(  # suppresses printed text
			testthat::expect_equal(
				user_rotate_graph(" "),
				list(flip=TRUE,rotate=45)
			)	
		)
	)
})





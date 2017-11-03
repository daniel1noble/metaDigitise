
context("Check graph_rotation...")


test_that("Checking user_rotate_graph..", {
	with_mock(
		internal_redraw = function(...){},
		readline = mock("f","r","c"),
		locator = function(...) list(x=c(1,2), y=c(1,2)),
		evaluate_promise(  # suppresses printed text
			expect_equal(
				user_rotate_graph(" "),
				list(flip=TRUE,rotate=45)
			)	
		)
	)
})





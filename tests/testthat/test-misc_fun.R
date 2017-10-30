
context("Check misc functions...")

test_that("Checking is.wholenumber..", {
	expect_equal(
		is.wholenumber(x=1), 
		TRUE, 
		info = "is.wholenumber failed")
})

test_that("Checking isNumeric..", {
	expect_equal(
		isNumeric(x=1), 
		TRUE, 
		info = "isNumeric failed")
})

test_that("Checking filename..", {
	expect_equal(
		filename(x="~/Dropbox/0_postdoc/10_metaDigitise/example_figs/5_fig2a.png"), 
		"5_fig2a.png", 
		info = "filename failed")
})



user_options_tester_func <- function(...) {
	with_mock(
		readline = function(question) "a",
		user_options (...)
		)
}

test_that("Checking user_options..", {
	expect_equal(
 		user_options_tester_func("question", c("a","b","c")), 
		"a",
		info = "user_options failed")
})
 

user_unique_tester_func <- function(...) {
	with_mock(
		readline = function(question) "d",
		user_unique (...)
		)
}

test_that("Checking user_unique..", {
	expect_equal(
 		user_unique_tester_func("question", c("a","b","c")), 
		"d",
		info = "user_unique failed")
})


user_numeric_tester_func <- function(..., user_entry) {
	with_mock(
		readline = function(question) user_entry,
		user_numeric (...)
		)
}

test_that("Checking user_numeric..", {
	expect_equal(
		user_numeric_tester_func("question",user_entry="1"), 
		1, 
		info = "user_numeric failed")
})


user_count_tester_func <- function(...) {
	with_mock(
		readline = function(question) "1",
		user_count (...)
		)
}

test_that("Checking user_count..", {
	expect_equal(
 		user_count_tester_func("question"), 
		1,
		info = "user_count failed")
})


ask_variable_tester_func <- function(...) {
	with_mock(
		readline = function(question) "x",
		ask_variable (...)
		)
}

test_that("Checking ask_variable..", {
	expect_equal(
 		ask_variable_tester_func(plot_type="scatterplot"), 
		c(y="x",x="x"), 
		info = "ask_variable failed")
	expect_equal(
 		ask_variable_tester_func(plot_type="mean_error"), 
		"x", 
		info = "ask_variable failed")
	expect_equal(
 		ask_variable_tester_func(plot_type="boxplot"), 
		"x", 
		info = "ask_variable failed")
	expect_equal(
 		ask_variable_tester_func(plot_type="histogram"), 
		"x", 
		info = "ask_variable failed")
})
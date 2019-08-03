extends "res://addons/gut/test.gd"

"""
I verify that GUT works as intended. 
I also serve as a copy-pasta smorgasbord.

I was initially copy-pasted from this page:
https://github.com/bitwes/Gut/wiki/Creating-Tests
"""

func before_each():
	gut.p("before each test", 2)

func after_each():
	gut.p("after each test", 2)

func before_all():
	gut.p("before all test", 2)

func after_all():
	gut.p("after all tests", 2)

func test_assert_eq_number_equal():
	assert_eq('asdf', 'asdf', "Should pass")

func test_assert_true_with_true():
	assert_true(true, "Should pass, true is true")
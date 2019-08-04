extends "res://addons/gut/test.gd"

"""
Verify that MapHandler at least does some tings right.

Ideally we should have tests on everything, 
but last minute perfectionism not a healtyhy JAM atitude.
"""

func test_that_set_tile_adjusts_position():
	var pos = Vector2(0.4, 1.7)
	MapHandler.set_tile(pos, 42)
	
	assert_eq(MapHandler.tiles[0][2], 42)


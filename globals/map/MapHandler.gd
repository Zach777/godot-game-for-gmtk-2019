"""
 Handles where units are at in the map.
"""
extends Node

#-1 for nonexisting, 
#0 for ground, 
#1 for player, 
#2 for enemy)

var tiles : Array = []

var tile_size : int = 32


func _ready():
	#Initialize the tiles.
	for i in range( 0,20 ) :
		var new_array : Array = []
		tiles.append( new_array )
		for y in range( 0,20 ) :
			var new_int : int = 0
			new_array.append( new_int )


func check_map( map : TileMap ) -> void :
	#Make the tiles into whatever the map is.
	pass


func get_tile( x_position : int, y_position : int ) -> int :
	return tiles[ x_position ][ y_position ]


func set_tile( x_position : int, y_position : int, value : int ) -> void :
	tiles[ x_position ][ y_position ] = value
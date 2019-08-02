"""
 Handles where units are at in the map.
"""
extends Node

#-1 for nonexisting, 
#0 for ground, 
#1 for player, 
#2 for enemy)

const GROUND = 0

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


func get_tile( tile : Vector2 ) -> int :
	return tiles[ tile.x ][ tile.y ]


func move_unit( from_tiles : Vector2, to_tile : Vector2 ) -> void :
	if tiles[ to_tile.x ][ to_tile.y ] != GROUND :
		return
	
	var swap_value : int = tiles[ from_tiles.x ][ from_tiles.y ]
	tiles[ from_tiles.x ][ from_tiles.y ] = 0
	tiles[ to_tile.x ][ to_tile.y ] = swap_value


func set_tile( tile : Vector2, value : int ) -> void :
	tiles[ tile.x ][ tile.y ] = value
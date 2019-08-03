"""
 Handles where units are at in the map.
"""
extends Node

#-1 for nonexisting, 
#0 for ground, 
#1 for player, 
#2 for enemy)

enum {GROUND, PLAYER, ENEMY}
const EMPTY = -1

var tiles : Array = []

var array_size = Vector2(20,20)

var tile_size : int = 32



func _ready():
	#Initialize the tiles.
	for i in range( 0,array_size.x ) :
		var new_array : Array = []
		tiles.append( new_array )
		for y in range( 0, array_size.y ) :
			var new_int : int = 0
			new_array.append( new_int )


func check_map( map : TileMap ) -> void :
	#Make the tiles into whatever the map is.
	pass


func get_tile( tile : Vector2 ) -> int :
	return tiles[ tile.x ][ tile.y ]


func move_unit( from_tiles : Vector2, to_tile : Vector2 ) -> bool :
	if tiles[ to_tile.x ][ to_tile.y ] != GROUND :
		return false
	if not (tile_in_map(from_tiles) and tile_in_map(to_tile)):
		return false
	var swap_value : int = tiles[ from_tiles.x ][ from_tiles.y ]
	tiles[ from_tiles.x ][ from_tiles.y ] = 0
	tiles[ to_tile.x ][ to_tile.y ] = swap_value
	return true


func set_tile( tile : Vector2, value : int ) -> void :
	if clamp(tile.x, 0, array_size.x-1) == tile.x and round(tile.x) == tile.x and clamp(tile.y, 0, array_size.y-1) == tile.y and round(tile.y) == tile.y:
		tiles[ tile.x ][ tile.y ] = value

func tile_in_map(tile : Vector2) -> bool:
	if clamp(tile.x, 0, array_size.x-1) == tile.x and round(tile.x) == tile.x and clamp(tile.y, 0, array_size.y-1) == tile.y and round(tile.y) == tile.y:
		return true
	else: return false
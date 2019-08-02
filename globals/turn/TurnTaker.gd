"""
 I make da tangs take da turns.
"""
extends CanvasLayer

"""
 At the _ready stage of a scene, all turn taking things
 call their respecive array and pass themselves to it.
 All turn taking things emit a signal named finished turn
 when they have completed a turn.
"""

var player_units : Array = []

var enemy_units : Array = []


func add_player_unit( unit : Object ) -> void :
	#Add the player unit to the scene.
	player_units.append( unit )


func add_enemy_unit( unit : Object ) -> void :
	#Add the enemy unit to the taker.
	enemy_units.append( unit )
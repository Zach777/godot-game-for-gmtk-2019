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

#These signals get called when a new turn is up.
signal player_begin_turn
signal enemy_begin_turn


var player_units : Array = []
var players_finished : int = 0

var enemy_units : Array = []
var enemies_finished : int = 0


func add_player_unit( unit : Object ) -> void :
	#Add the player unit to the scene.
	player_units.append( unit )
	unit.connect( "finished_turn", self, "player_unit_finished" )


func add_enemy_unit( unit : Object ) -> void :
	#Add the enemy unit to the taker.
	enemy_units.append( unit )
	unit.connect( "finished_turn", self, "enemy_unit_finished" )


func clear() -> void :
	#Remove all active units.
	#Do this when you are moving to a new scene.
	player_units.clear()
	enemy_units.clear()
	enemies_finished = 0
	players_finished = 0


func enemy_unit_finished() -> void :
	enemies_finished += 1
	if enemies_finished == enemy_units.size() :
		enemies_finished = 0
		emit_signal( "player_begin_turn" )


func player_unit_finished() -> void :
	players_finished += 1
	if players_finished == player_units.size() :
		players_finished = 0
		emit_signal( "enemy_begin_turn" )
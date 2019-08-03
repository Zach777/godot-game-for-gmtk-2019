"""
 An ant hill that creates more ants
 after so many turns.
"""
extends Area2D


const START_HEALTH = 3

export var is_players : bool = false
export var place_ant : Vector2 = Vector2( 0,1 )

var health = 3

var positionInArray : Vector2

onready var checker : Area2D = get_node( "Checker" )

#Each time I am told to produce, 
#I decrement wait_to_produce. When wait_to_produce is done,
#I make a new ant based on my faction.
"""
There is a bug present unfortunately.
Enemy calls turn multiple times in a turn.
"""
var wait_to_produce : int = 10
var start_wait : int = wait_to_produce
var can_produce : bool = true

signal finished_turn


func _ready():
	positionInArray = position / MapHandler.tile_size
	
	#Listen for the correct signal.
	if is_players :
		TurnTaker.add_player_unit( self )
		TurnTaker.connect( "player_begin_turn", self, "player_turn" )
		MapHandler.set_tile( positionInArray, MapHandler.PLAYER )
		
		get_tree().get_nodes_in_group( "ActionSelect" )[0].connect( "produce_pressed", self, "produce" )
		
		#Make sure others know what side I am on.
		self.set_collision_layer_bit( 0, true )
	else :
		TurnTaker.add_enemy_unit( self )
		TurnTaker.connect( "enemy_begin_turn", self, "enemy_turn" )
		MapHandler.set_tile( positionInArray, MapHandler.ENEMY )
		self.set_collision_layer_bit( 2, true )


func enemy_turn() -> void :
	if can_produce == false :
		emit_signal("finished_turn")
		return
	
	wait_to_produce = max( 0, wait_to_produce - 1 )
	if ( wait_to_produce == 0 &&
			checker.get_overlapping_areas().size() <= 1 ) :
		wait_to_produce = start_wait
		var enemy = load( "res://ants/Enemy.tscn" ).instance()
		enemy.set_map_location( positionInArray + place_ant )
		get_tree().get_nodes_in_group( "enemies" )[0].add_child( enemy )
	
	emit_signal("finished_turn")


func produce() -> void :
	#I have been told to produce an ant.
	if can_produce == false :
		return
	
	wait_to_produce = max( 0, wait_to_produce - 2 )
	if( wait_to_produce == 0 &&
			checker.get_overlapping_areas().size() <= 1) :
		wait_to_produce = start_wait
		var player = load( "res://ants/Player.tscn" ).instance()
		player.set_map_location( positionInArray + place_ant )
		get_tree().get_nodes_in_group( "players" )[0].add_child( player )


func player_turn() -> void :
	emit_signal("finished_turn")


func take_damage( amount : int ) -> void :
	health -= amount
	if health <= 0 :
		health = START_HEALTH
		wait_to_produce = start_wait
		if is_players :
			TurnTaker.remove_player_unit( self )
			is_players = false
			TurnTaker.add_enemy_unit( self )
			MapHandler.set_tile( positionInArray, MapHandler.PLAYER )
			self.set_collision_layer_bit( 0, false )
			self.set_collision_layer_bit( 2, true )
			get_tree().get_nodes_in_group( "ActionSelect" )[0].disconnect( "produce_pressed", self, "produce" )
		else:
			TurnTaker.remove_enemy_unit( self )
			is_players = true
			TurnTaker.add_player_unit( self )
			MapHandler.set_tile( positionInArray, MapHandler.ENEMY )
			self.set_collision_layer_bit( 0, true )
			self.set_collision_layer_bit( 2, false)
			get_tree().get_nodes_in_group( "ActionSelect" )[0].connect( "produce_pressed", self, "produce" )
"""
 An ant hill that creates more ants
 after so many turns.
"""
extends Area2D


const START_HEALTH = 3

export var is_players : bool = false
export var place_ant : Vector2 = Vector2( 0,1 )
export var double_produce : bool = false

var health = 3

var positionInArray : Vector2

onready var checker : Area2D = get_node( "Checker" )
onready var hill_count : Node
onready var label : Label = get_node( "Label" )

#Each time I am told to produce, 
#I decrement wait_to_produce. When wait_to_produce is done,
#I make a new ant based on my faction.
var wait_to_produce : int = 2
var start_wait : int = wait_to_produce
var can_produce : bool = true

#Each item brought by the player will fill this
#up by one. Each ant creation uses one.
var item_stock : int = 0

signal finished_turn


func _process(delta):
	if is_players == false :
		for area in checker.get_overlapping_areas() :
			if area.has_method( "get_carrier" ) :
				var carrier : Object = area.get_carrier()
				if carrier.has_method( "is_enemy" ) :
					carrier.emit_signal( "delivered_item" )
					can_produce = true
					area.queue_free()
	
	else :
		for area in checker.get_overlapping_areas() :
			if area.has_method( "get_carrier" ) :
				var carrier : Object = area.get_carrier()
				if carrier.has_method( "is_player" ) :
					can_produce = true
					item_stock += 1
					label.text = str( item_stock )
					area.queue_free()


func _ready():
	hill_count = get_tree().get_nodes_in_group( "HillCount" )[0]
	
	positionInArray = position / MapHandler.tile_size
	hill_count.add_hill()
	
	#Listen for the correct signal.
	if is_players :
		label.show()
		label.text = str( item_stock )
		TurnTaker.add_player_unit( self )
		TurnTaker.connect( "player_begin_turn", self, "player_turn" )
		MapHandler.set_tile( positionInArray, MapHandler.PLAYER )
		
		get_tree().get_nodes_in_group( "ActionSelect" )[0].connect( "produce_pressed", self, "produce" )
		hill_count.hill_infected()
		
		#Make sure others know what side I am on.
		self.set_collision_layer_bit( 0, true )
		
		call_deferred( "produce" )
		
	else :
		label.hide()
		TurnTaker.add_enemy_unit( self )
		TurnTaker.connect( "enemy_begin_turn", self, "enemy_turn" )
		MapHandler.set_tile( positionInArray, MapHandler.ENEMY )
		self.set_collision_layer_bit( 2, true )
		self.call_deferred( "enemy_produce" )


func enemy_turn() -> void :
	if can_produce == false :
		emit_signal("finished_turn")
		return
	
	if ( wait_to_produce == 0 &&
			checker.get_overlapping_areas().size() <= 1 ) :
		wait_to_produce = start_wait
		enemy_produce(place_ant)
		if double_produce :
			enemy_produce( place_ant.rotated( deg2rad(90) ) )
		can_produce = false
	wait_to_produce = max( 0, wait_to_produce - 1 )
	
	emit_signal("finished_turn")


func enemy_produce(place) -> void :
	var scene = load( "res://ants/Enemy.tscn" )
	var enemy = scene.instance()
	enemy.set_map_location( positionInArray + place )
	enemy.home_ant_hill( self )
	get_tree().get_nodes_in_group( "enemies" )[0].add_child( enemy )
	
	var new_enemy = scene.instance()
	new_enemy.set_map_location( positionInArray + place.rotated( deg2rad(180) ) )
	new_enemy.home_ant_hill( self )
	get_tree().get_nodes_in_group( "enemies" )[0].add_child( new_enemy )


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
		item_stock = max( 0, item_stock - 1 )
		if item_stock == 0 :
			can_produce = false
		label.text = str( item_stock )


func player_turn() -> void :
	#Check if the player has brought me an item.
	emit_signal("finished_turn")


func take_damage( amount : int ) -> void :
	health -= amount
	if health <= 0 :
		health = START_HEALTH
		wait_to_produce = start_wait
		if is_players :
			label.hide()
			can_produce = true
			TurnTaker.remove_player_unit( self )
			is_players = false
			TurnTaker.add_enemy_unit( self )
			MapHandler.set_tile( positionInArray, MapHandler.PLAYER )
			hill_count.hill_cured()
			self.set_collision_layer_bit( 0, false )
			self.set_collision_layer_bit( 2, true )
			TurnTaker.disconnect( "player_begin_turn", self, "player_turn" )
			get_tree().get_nodes_in_group( "ActionSelect" )[0].disconnect( "produce_pressed", self, "produce" )
		else:
			label.show()
			label.text = str( item_stock )
			TurnTaker.remove_enemy_unit( self )
			is_players = true
			TurnTaker.add_player_unit( self )
			MapHandler.set_tile( positionInArray, MapHandler.ENEMY )
			hill_count.hill_infected()
			self.set_collision_layer_bit( 0, true )
			self.set_collision_layer_bit( 2, false)
			TurnTaker.disconnect( "enemy_begin_turn", self, "enemy_turn" )
			get_tree().get_nodes_in_group( "ActionSelect" )[0].connect( "produce_pressed", self, "produce" )
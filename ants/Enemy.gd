extends Area2D

export (int) var health = 2
export (int) var damage = 2

signal finished_turn
signal health_changed
signal grabbed_item
signal delivered_item

const Player = preload("res://ants/Player.tscn")

onready var main_sprite : Sprite = get_node("main_sprite")
onready var checker : Area2D = get_node( "Checker" )

var positionInArray = Vector2()

var home_ant_hill: Area2D = self

#When I have an item, proceed straight to your ant hill.
var has_item : bool = false

var is_dead : bool = false

func _ready():
	#Set my position in the array based on position.
	positionInArray = position / MapHandler.tile_size
	MapHandler.set_tile( positionInArray, MapHandler.ENEMY )
	TurnTaker.add_enemy_unit( self )
	
	position = positionInArray * MapHandler.tile_size
	
	TurnTaker.connect( "enemy_begin_turn", self, "turn" )
	
	self.connect( "grabbed_item", self, "grabbed_item" )
	self.connect( "delivered_item", self, "delivered_item" )


func delivered_item() -> void :
	has_item = false

func grabbed_item() -> void :
	has_item = true

func home_ant_hill( ant_hill : Area2D) -> void :
	home_ant_hill = ant_hill

func tile() -> int:
	return MapHandler.tiles[positionInArray.x][positionInArray.y]

func is_enemy() -> bool :
	return true

func player_near() -> Vector2:
	if MapHandler.get_tile(Vector2( positionInArray.x+1, positionInArray.y ) ) == 1:
		return Vector2(positionInArray.x+1, positionInArray.y)
	elif MapHandler.get_tile(Vector2( positionInArray.x-1, positionInArray.y ) ) == 1:
		return Vector2(positionInArray.x-1, positionInArray.y)
	elif MapHandler.get_tile(Vector2( positionInArray.x, positionInArray.y+1 ) ) == 1:
		return Vector2(positionInArray.x, positionInArray.y+1)
	elif MapHandler.get_tile(Vector2( positionInArray.x, positionInArray.y-1) ) == 1:
		return Vector2(positionInArray.x, positionInArray.y-1)
	return Vector2(-1, -1)

func set_map_location( location_in_map : Vector2 ) -> void :
	positionInArray = location_in_map
	position = positionInArray * MapHandler.tile_size

func turn():
	var nearest_player : Area2D
	if home_ant_hill != self :
		if home_ant_hill.is_players :
			nearest_player = home_ant_hill
		elif has_item :
			nearest_player = home_ant_hill
		else :
			nearest_player = nearest_player()
	else :
		nearest_player = nearest_player()
		
	if nearest_player.position.x == position.x: #same x, move y
		if nearest_player.position.y > position.y:
			positionInArray = MapHandler.move_unit(positionInArray, positionInArray + Vector2.DOWN)
		else:
			positionInArray = MapHandler.move_unit(positionInArray, positionInArray + Vector2.UP)
	elif nearest_player.position.y == position.y: #same y, move x
		if nearest_player.position.x > position.x:
			positionInArray = MapHandler.move_unit(positionInArray, positionInArray + Vector2.RIGHT)
		else:
			positionInArray = MapHandler.move_unit(positionInArray, positionInArray + Vector2.LEFT)
	else: #move either way
		if round(rand_range(0,1)) == 0:
			if nearest_player.position.y > position.y:
				positionInArray = MapHandler.move_unit(positionInArray, positionInArray + Vector2.DOWN)
			else:
				positionInArray = MapHandler.move_unit(positionInArray, positionInArray + Vector2.UP)
		else:
			if nearest_player.position.x > position.x:
				positionInArray = MapHandler.move_unit(positionInArray, positionInArray + Vector2.RIGHT)
			else:
				positionInArray = MapHandler.move_unit(positionInArray, positionInArray + Vector2.LEFT)
	
	#Move the enemy unit.
	position = positionInArray * MapHandler.tile_size
	
	#Attack the player if player is close.
	if player_near() != Vector2( -1,-1 ):
		for player in checker.get_overlapping_areas():
			if player.has_method("take_damage"): player.take_damage(damage)
	
	#Finish the turn gracefully.
	emit_signal("finished_turn")

func nearest_player() -> Area2D:
	var nearest : Area2D
	var players : Array = get_tree().get_nodes_in_group("player_units")
	if players.size() > 0 : 
		nearest = players[ 0 ]
	var at : int = 1
	while at < players.size() :
		var player : Area2D = players[at]
		var distance = (position - player.position).length()
		if distance <= (position - nearest.position).length(): nearest = player
		at += 1
	
	if home_ant_hill != self :
		for item in get_tree().get_nodes_in_group( "items" ) :
			var distance = (position - item.position).length()
			if distance <= (position - nearest.position).length() :
				nearest = item
	
	if nearest == null :
		pass
	return nearest

func take_damage(var dmg : int):
	if is_dead :
		return 
	health -= dmg
	emit_signal("health_changed", health)
	if health <= 0: 
		die()

func die():
	is_dead = true
	MapHandler.set_tile(positionInArray, MapHandler.PLAYER)
	var newPlayerUnit = Player.instance()
	newPlayerUnit.positionInArray = positionInArray
	TurnTaker.remove_enemy_unit(self)
	newPlayerUnit.set_map_location( positionInArray )
	get_tree().get_nodes_in_group( "players" )[0].add_child( newPlayerUnit )
	self.queue_free()
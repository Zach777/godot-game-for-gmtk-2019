extends Area2D
var positionInArray = Vector2()

export (int) var health = 1

signal finished_turn
signal health_changed

const Player = preload("res://ants/Player.tscn")

func _ready():
	MapHandler.set_tile( positionInArray, MapHandler.ENEMY )
	position = positionInArray * MapHandler.tile_size
	
	TurnTaker.connect( "enemy_begin_turn", self, "turn" )

func tile() -> int:
	return MapHandler.tiles[positionInArray.x][positionInArray.y]

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

func turn():
	if player_near() != Vector2( -1,-1 ):
		self.position = player_near()
		for player in self.get_overlapping_areas():
			if player.has_method("take_damage"): player.take_damage(1)
	else:
		var nearest_player = nearest_player()
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
	
	#Finish the turn gracefully.
	emit_signal("finished_turn")

func nearest_player() -> Area2D:
	var nearest_player : Area2D
	for player in get_tree().get_nodes_in_group("player_units"):
		var distance = (position - player.position).length()
		if distance <= (position - player.position).length(): nearest_player = player
	return nearest_player

func take_damage(var dmg : int):
	health -= dmg
	emit_signal("health_changed")
	if health <= 0: die()

func die():
	MapHandler.set_tile(positionInArray, 1)
	var newPlayerUnit = Player.instance()
	newPlayerUnit.positionInArray = positionInArray
	TurnTaker.remove_enemy_unit(self)
	newPlayerUnit.position = positionInArray * MapHandler.tile_size+Vector2(MapHandler.tile_size/2, MapHandler.tile_size/2)
	TurnTaker.add_player_unit(newPlayerUnit)
	self.queue_free()
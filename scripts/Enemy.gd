extends Node2D
var positionInArray = Vector2()

export (int) var health = 1

signal finished_turn
signal health_changed

func _ready():
	MapHandler.set_tile( positionInArray, MapHandler.ENEMY )
	position = positionInArray*$"/root/MapHandler".tile_size
	
	TurnTaker.connect( "enemy_begin_turn", self, "turn" )

func tile() -> int:
	return $"/root/MapHandler".tiles[positionInArray.x][positionInArray.y]

func player_near() -> Vector2:
	if $"/root/MapHandler".get_tile(Vector2( positionInArray.x+1, positionInArray.y ) ) == 1:
		return Vector2(positionInArray.x+1, positionInArray.y)
	elif $"/root/MapHandler".get_tile(Vector2( positionInArray.x-1, positionInArray.y ) ) == 1:
		return Vector2(positionInArray.x-1, positionInArray.y)
	elif $"/root/MapHandler".get_tile(Vector2( positionInArray.x, positionInArray.y+1 ) ) == 1:
		return Vector2(positionInArray.x, positionInArray.y+1)
	elif $"/root/MapHandler".get_tile(Vector2( positionInArray.x, positionInArray.y-1) ) == 1:
		return Vector2(positionInArray.x, positionInArray.y-1)
	return Vector2(-1, -1)

func turn():
	if player_near() != Vector2( -1,-1 ):
		$Area2D.position = player_near()
		for player in $Area2D.get_overlapping_areas():
			if player.has_method("take_damage"): player.take_damage(1)
	else:
		var nearest_player = nearest_player()
		if nearest_player.position.x == position.x: #same x, move y
			if nearest_player.y > position.y:
				positionInArray = $"/root/MapHandler".move_unit(positionInArray, positionInArray + Vector2.DOWN)
			else:
				positionInArray = $"/root/MapHandler".move_unit(positionInArray, positionInArray + Vector2.UP)
		elif nearest_player.position.y == position.y: #same y, move x
			if nearest_player.position.x > position.x:
				positionInArray = $"/root/MapHandler".move_unit(positionInArray, positionInArray + Vector2.RIGHT)
			else:
				positionInArray = $"/root/MapHandler".move_unit(positionInArray, positionInArray + Vector2.LEFT)
		else: #move either way
			if round(rand_range(0,1)) == 0:
				if nearest_player.y > position.y:
					positionInArray = $"/root/MapHandler".move_unit(positionInArray, positionInArray + Vector2.DOWN)
				else:
					positionInArray = $"/root/MapHandler".move_unit(positionInArray, positionInArray + Vector2.UP)
			else:
				if nearest_player.x > position.x:
					positionInArray = $"/root/MapHandler".move_unit(positionInArray, positionInArray + Vector2.RIGHT)
				else:
					positionInArray = $"/root/MapHandler".move_unit(positionInArray, positionInArray + Vector2.LEFT)
		
		#Move the enemy unit.
		position = positionInArray*$"/root/MapHandler".tile_size
	
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
	$"/root/MapHandler".set_tile(positionInArray, 1)
	var newPlayerUnit = load("res://ants/player/Player.tscn").instance() #TODO!!! CHANGE THIS TO PLAYER SCENE
	newPlayerUnit.positionInArray = positionInArray
	$"/root/TurnTaker".remove_enemy_unit(self)
	newPlayerUnit.position = positionInArray*$"/root/MapHandler".tile_size+Vector2($"/root/MapHandler".tile_size/2, $"/root/MapHandler".tile_size/2)
	$"/root/TurnTaker".add_player_unit(newPlayerUnit)
	self.queue_free()
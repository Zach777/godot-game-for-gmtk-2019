extends Area2D

export (int) var damage = 1
export (int) var health = 2

signal finished_turn
signal health_changed

onready var main_sprite : Sprite = get_node("main_sprite")
onready var checker : Area2D = get_node( "Checker" )

var positionInArray = Vector2()
var guarding = false


# Called when the node enters the scene tree for the first time.
func _ready():
	#Set my position based on where I am in the map.
	positionInArray = position / MapHandler.tile_size
	MapHandler.set_tile( positionInArray, MapHandler.PLAYER )
	TurnTaker.add_player_unit( self )
	
	for select in get_tree().get_nodes_in_group("ActionSelect"):
		select.connect("attack_pressed", self, "attack")
		select.connect("guard_pressed", self, "guard")
		select.connect("move_pressed", self, "move")
		select.connect( "rotate_pressed", self, "pass_turn" )
	connect("finished_turn", TurnTaker, "player_unit_finished")
	position = positionInArray*MapHandler.tile_size
	
	MapHandler.set_tile( positionInArray, MapHandler.PLAYER )

func process(delta):
	position = positionInArray*MapHandler.tile_size

func attack():
	if( checker.get_overlapping_areas().size() > 0):
		for enemy in checker.get_overlapping_areas():
			if enemy.has_method("take_damage"): enemy.take_damage(damage)
	guarding = false
	emit_signal("finished_turn")

func guard():
	guarding = true
	emit_signal("finished_turn")

func is_player() -> bool :
	return true

func move( move_by : Vector2 ):
	positionInArray = MapHandler.move_unit(positionInArray, positionInArray+move_by)
	position = positionInArray * MapHandler.tile_size
	guarding = false
	emit_signal("finished_turn")

func pass_turn() -> void :
	self.emit_signal( "finished_turn" )

func set_map_location( location_in_map : Vector2 ) -> void :
	#Set my position based on the location passed.
	positionInArray = location_in_map
	position = MapHandler.tile_size * positionInArray

func take_damage(damage : int):
	if guarding:
		health -= damage - 1
		self.emit_signal( "health_changed", health )
	else:
		health -= damage
		self.emit_signal( "health_changed", health )
	if health <= 0:
		MapHandler.set_tile( positionInArray, MapHandler.GROUND )
		TurnTaker.remove_player_unit(self)
		self.emit_signal( "health_changed", health )
		self.queue_free()
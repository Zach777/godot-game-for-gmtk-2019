extends Area2D

export (int) var damage = 1
export (int) var health = 2

signal finished_turn
signal health_changed

onready var main_sprite : Sprite = get_node("main_sprite")

var pointing = Vector2(1,0)
var positionInArray = Vector2()
var guarding = false


# Called when the node enters the scene tree for the first time.
func _ready():
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
	if(MapHandler.get_tile(positionInArray+pointing)==MapHandler.ENEMY):
		self.position = (positionInArray+pointing)*MapHandler.tile_size
		for enemy in self.get_overlapping_areas():
			if enemy.has_method("take_damage"): enemy.take_damage(damage)
	guarding = false
	$AnimationPlayer.play("Attack")
	yield($AnimationPlayer,"animation_finished")
	emit_signal("finished_turn")

func guard():
	guarding = true
	emit_signal("finished_turn")

func move( move_by : Vector2 ):
	positionInArray = MapHandler.move_unit(positionInArray, positionInArray+move_by)
	position = positionInArray * MapHandler.tile_size
	guarding = false
	emit_signal("finished_turn")

func pass_turn() -> void :
	self.emit_signal( "finished_turn" )

func take_damage(damage : int):
	if guarding:
		health -= damage - 1
	else:
		health -= damage
	if health <= 0:
		TurnTaker.remove_player_unit(self)
		self.queue_free()
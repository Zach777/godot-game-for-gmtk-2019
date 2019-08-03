extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var damage = 1
export (int) var health = 2
var pointing = Vector2(1,0)
var positionInArray = Vector2()
var guarding = false

signal finished_turn
signal health_changed
# Called when the node enters the scene tree for the first time.
func _ready():
	for select in get_tree().get_nodes_in_group("ActionSelect"):
		select.connect("attack_pressed", self, "attack")
		select.connect("guard_pressed", self, "guard")
		select.connect("move_pressed", self, "move")
	connect("finished_turn", $"/root/TurnTaker", "player_unit_finished")
	position = positionInArray*$"/root/MapHandler".tile_size

func process(delta):
	position = positionInArray*$"/root/MapHandler".tile_size

func attack():
	if($"/root/MapHandler".get_tile(positionInArray+pointing)==$"/root/MapHandler".ENEMY):
		$Area2D.position = (positionInArray+pointing)*$"/root/MapHandler".tile_size
		for enemy in $Area2D.get_overlapping_areas():
			if enemy.has_method("take_damage"): enemy.take_damage(damage)
	guarding = false
	$AnimationPlayer.play("Attack")
	yield($AnimationPlayer,"animation_finished")
	emit_signal("finished_turn")

func guard():
	guarding = true
	emit_signal("finished_turn")

func move():
	if $"/root/MapHandler".move_unit(positionInArray, positionInArray+pointing):
		positionInArray += pointing
		position = positionInArray*$"/root/MapHandler".tile_size
	guarding = false
	emit_signal("finished_turn")

func take_damage(damage : int):
	if guarding:
		health -= damage - 1
	else:
		health -= damage
	if health <= 0:
		$"/root/TurnTaker".remove_player_unit(self)
		self.queue_free()
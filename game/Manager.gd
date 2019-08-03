extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var firstPlayer = preload("res://ants/player/Player.tscn").instance()
	firstPlayer.positionInArray = Vector2(3,3)
	$"/root/TurnTaker".add_player_unit(firstPlayer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

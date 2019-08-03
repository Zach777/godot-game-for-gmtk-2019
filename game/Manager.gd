extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var firstPlayer = preload("res://ants/Player.tscn").instance()
	firstPlayer.positionInArray = Vector2(3,3)
	
	#Add one enemy.
	var enemy = preload( "res://ants/Enemy.tscn" ).instance()
	enemy.positionInArray = Vector2( 8,3 )

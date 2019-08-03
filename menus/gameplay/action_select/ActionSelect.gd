"""
 The action select menu. Uses signals to 
 let whatever is curious know what button is being
 pressed.
  It does not know what turn is up, so you
 have to let ActionSelect know when it can
 select.
"""
extends CanvasLayer


signal move_pressed
signal rotate_pressed
signal attack_pressed
signal guard_pressed

onready var z : Node2D = get_node( "z" )
onready var unit_count  : RichTextLabel = z.get_node( "UnitCount" )


func _ready():
	#I want give the first child after Panel 
	#ui focus.
	z.get_child( 1 ).grab_focus()
	
	#Connect button presses to myself.
	z.get_node( "Move" ).connect( "pressed", self, "move_pressed" )
	z.get_node( "Rotate" ).connect( "pressed", self, "rotate_pressed" )
	z.get_node( "Attack" ).connect( "pressed", self, "attack_pressed" )
	z.get_node( "Guard" ).connect( "pressed", self, "guard_pressed" )
	
	#Listen for player count changes.
	TurnTaker.connect( "players_count_changed", self, "update_unit_count" )


func attack_pressed() -> void :
	emit_signal( "attack_pressed" )


func guard_pressed() -> void :
	emit_signal( "guard_pressed" )


func move_pressed() -> void :
	emit_signal( "move_pressed" )


#Call this method when you want something
#connected to ActionSelect.
func plug_in( object_to_connect : Object ) -> void :
	#Connects the signal I have to object_to_connect.
	pass


func rotate_pressed() -> void :
	emit_signal( "rotate_pressed" )


func update_unit_count( new_count : int ) -> void :
	unit_count.text = str( new_count )



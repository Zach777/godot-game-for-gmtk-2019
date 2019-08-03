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
onready var move : Popup = z.get_node( "Move/C/MoveMenu" )
onready var unit_count  : RichTextLabel = z.get_node( "UnitCount" )


func _ready():
	#I want give the first child after Panel 
	#ui focus.
	z.get_child( 1 ).grab_focus()
	
	#Connect button presses to myself.
	z.get_node( "Move" ).connect( "pressed", self, "move_pressed" )
	z.get_node( "Produce" ).connect( "pressed", self, "rotate_pressed" )
	z.get_node( "Attack" ).connect( "pressed", self, "attack_pressed" )
	z.get_node( "Guard" ).connect( "pressed", self, "guard_pressed" )

	move.get_node( "Up" ).connect( "pressed", self, "move_up" )
	move.get_node( "Down" ).connect( "pressed", self, "move_down" )
	move.get_node( "Right" ).connect( "pressed", self, "move_right" )
	move.get_node( "Left" ).connect( "pressed", self, "move_left" )
	
	#Listen for player count changes.
	TurnTaker.connect( "players_count_changed", self, "update_unit_count" )


func attack_pressed() -> void :
	move.hide()
	emit_signal( "attack_pressed" )


func guard_pressed() -> void :
	move.hide()
	emit_signal( "guard_pressed" )


func move_pressed() -> void :
	#Bring up the movement menu.
	move.show()


func move_up() -> void :
	move.hide()
	self.emit_signal( "move_pressed", Vector2( 0,-1 ) )


func move_down() -> void :
	move.hide()
	self.emit_signal( "move_pressed", Vector2( 0,1 ) )


func move_left() -> void :
	move.hide()
	self.emit_signal( "move_pressed", Vector2( -1,0) )


func move_right() -> void :
	move.hide()
	self.emit_signal( "move_pressed", Vector2( 1,0 ) )


#Call this method when you want something
#connected to ActionSelect.
func plug_in( object_to_connect : Object ) -> void :
	#Connects the signal I have to object_to_connect.
	pass


func rotate_pressed() -> void :
	move.hide()
	emit_signal( "rotate_pressed" )


func update_unit_count( new_count : int ) -> void :
	unit_count.text = str(new_count)
	if new_count == 1 :
		unit_count.text += " ant infected"
	else:
		unit_count.text += " ants infected"
		
		
	



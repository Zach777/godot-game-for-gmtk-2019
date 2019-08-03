"""
 The pause button.
"""
extends Popup


func _process(delta):
	if Input.is_action_just_pressed( "ui_end" ) :
		if get_tree().paused == false :
			get_tree().paused = true
			self.show()
		else :
			get_tree().paused = false
			self.hide()


func _ready():
	get_node( "Panel/VBoxContainer/Continue" ).connect( "pressed", self, "continue_pressed" )


func continue_pressed() -> void :
	self.hide()
	get_tree().paused = false
"""
 When all hills are infected, victory is acheived.
"""
extends Node

#How many hills the player owns.
var hills_infected : int = 0

#How many hills there are total.
var hills_total : int = 0

var can_win : bool = false

func _ready():
	call_deferred( "win_allowed" )

func win_allowed() -> void :
	can_win = true

func add_hill() -> void :
	hills_total += 1

func hill_cured() -> void :
	hills_infected -= 1

func hill_infected() -> void :
	hills_infected += 1
	
	if can_win :
		TurnTaker.clear()
		MapHandler.clear_map()
		get_tree().change_scene( "res://menus/main_menu/MainMenu.tscn" )


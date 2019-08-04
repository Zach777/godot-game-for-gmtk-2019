"""
 When all hills are infected, victory is acheived.
"""
extends Node

#How many hills the player owns.
var hills_infected : int = 0

#How many hills there are total.
var hills_total : int = 0

#You can only win when the game is actually being played.
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
	
	if can_win && hills_infected == hills_total:
		get_tree().call_group( "Victory", "start" )
		


"""
 When all hills are infected, victory is acheived.
"""
extends Node

#How many hills the player owns.
var hills_infected : int = 0

#How many hills there are total.
var hills_total : int = 0


func add_hill() -> void :
	hills_total += 1

func hill_cured() -> void :
	hills_infected -= 1

func hill_infected() -> void :
	hills_infected += 1


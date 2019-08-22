"""
 Handles the settings of the game the player is 
 allowed to toggle.
"""
extends Node

var music_volume : float = 0
const MUSIC_MAX = 24
const MUSIC_MIN = -80

var music_active : bool = true
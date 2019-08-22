"""
 Checks for the global music volume
 and adjusts it's volume accordingly.
"""
extends AudioStreamPlayer

func _init():
	self.volume_db = GameSettings.music_volume
	self.playing = GameSettings.music_active
	self.autoplay = GameSettings.music_active
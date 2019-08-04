extends Area2D


var being_carried : bool = false
var carrier : Object = self

var positionInArray : Vector2


func _ready():
	positionInArray = position / MapHandler.tile_size
	
	TurnTaker.connect( "enemy_begin_turn", self, "check" )
	TurnTaker.connect( "player_begin_turn", self, "check" )


func carrier_health( amount : int ) -> void :
	if amount <= 0 :
		being_carried = false
		carrier = self

func check() -> void :
	#See if anyone is overlapping me.
	if being_carried :
		self.position = carrier.position
		
	else:
		var overlap : Array = get_overlapping_areas()
		if overlap.size() > 0 :
			carrier = overlap[0]
			being_carried = true
			carrier.connect( "health_changed", self, "carrier_health" )
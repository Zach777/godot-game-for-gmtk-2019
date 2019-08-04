extends Area2D


var being_carried : bool = false
var carrier : Object = self

var positionInArray : Vector2

signal delivered


func _ready():
	positionInArray = position / MapHandler.tile_size
	
	self.connect( "delivered", self, "delivered" )


func carrier_health( amount : int ) -> void :
	if amount <= 0 :
		being_carried = false
		carrier = self
		self.add_to_group( "items" )

func _process(delta) -> void :
	#See if anyone is overlapping me.
	if being_carried :
		self.position = carrier.position
		positionInArray = carrier.positionInArray
		
	else:
		var overlap : Array = get_overlapping_areas()
		if overlap.size() > 0 :
			self.remove_from_group( "items" )
			carrier = overlap[0]
			carrier.emit_signal( "grabbed_item" )
			being_carried = true
			carrier.connect( "health_changed", self, "carrier_health" )


func delivered() -> void :
	carrier.emit_signal( "delivered_item" )


func get_carrier() -> Object :
	return carrier







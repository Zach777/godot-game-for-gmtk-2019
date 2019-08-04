extends Sprite

var item_scene : PackedScene = preload( "res://game/Item.tscn" )


var positionInArray : Vector2

var wait : int = 20
const START_WAIT = 20
var needs_new : bool = false

var item : Area2D


func _ready():
	positionInArray = position / MapHandler.tile_size
	
	make()
	
	TurnTaker.connect( "player_begin_turn", self, "player_turn" )
	TurnTaker.connect( "enemy_begin_turn", self, "enemy_turn" )


func decrement() -> void :
	if needs_new :
		wait -= 1
		if wait == 0 :
			make()


func delivered() -> void :
	item.disconnect( "delivered", self, "delivered" )


func enemy_turn() -> void :
	decrement()


func item_grabbed() -> void :
	needs_new = true
	item.disconnect( "grabbed", self, "item_grabbed" )


func make() -> void :
	needs_new = false
	wait = START_WAIT
	
	item = item_scene.instance()
	item.position = self.position
	item.connect( "grabbed", self, "item_grabbed" )
	item.connect( "delivered", self, "delivered" )
	get_parent().call_deferred( "add_child", item )


func player_turn() -> void :
	decrement()
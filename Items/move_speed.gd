extends Item
class_name MoveSpeedItem

@export var speed : float = 0.1

func get_item(e : Entity):
	super.get_item(e)
	e.speed_multiplier += speed
	
func remove_item(e : Entity):
	e.speed_multiplier -= speed

extends Item
class_name EclipseHeart

@export var regen_amt : float = 10

var p : Entity

func get_item(e : Entity):
	super.get_item(e)
	p = e
	if !WorldTime.on_time_change.is_connected(on_phase):
		WorldTime.on_time_change.connect(on_phase)

func on_phase():
	p.take_damage(null, -regen_amt - 5 * (stack - 1), 0.0)

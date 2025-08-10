extends Item
class_name BurningAmulet

@export var effect : Item

func get_item(e : Entity):
	super.get_item(e)
	if !e.on_hit.is_connected(on_hit):
		e.on_hit.connect(on_hit)

func on_hit(a : Entity, t : Entity, dmg : float, proc : float):
	if !WorldTime.get_sun(): return
	var r := randf()
	if r <= (0.1 + 0.1 * (stack - 1)) * proc:
		t.get_item(effect)

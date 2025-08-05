extends Item
class_name DmgOnHit

@export var dmghit : float = 2

func get_item(e : Entity):
	super.get_item(e)
	if !e.on_hit.is_connected(on_hit):
		e.on_hit.connect(on_hit)

func on_hit(a : Entity, t : Entity, dmg : float, proc : float):
	if WorldTime.get_moon():
		t.take_damage(a, dmghit + (2 * (stack - 1)) * proc, 0.1)

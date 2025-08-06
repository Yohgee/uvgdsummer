extends Item
class_name HealOnHit

@export var healhit : float = 0.1

func get_item(e : Entity):
	super.get_item(e)
	if !e.on_hit.is_connected(on_hit):
		e.on_hit.connect(on_hit)

func on_hit(a : Entity, t : Entity, dmg : float, proc : float):
	if dmg <= 0: return
	if WorldTime.get_sun():
		var r := randf()
		if r <= (0.10 + (0.02 * (stack - 1))) * proc:
			a.take_damage(null, -dmg * (healhit + 0.05 * (stack - 1)), 0.0)

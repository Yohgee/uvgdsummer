extends Item
class_name MoonShield

func get_item(e : Entity):
	super.get_item(e)
	if !e.on_damage.is_connected(on_damage):
		e.on_damage.connect(on_damage)

func on_damage(a : Entity, t : Entity, dmg : float, proc : float):
	if dmg <= 0: return
	if WorldTime.get_moon():
		if t is Player:
			t.charge += dmg * 0.2 * (stack)

extends Item
class_name ChargeCrystal

func get_item(e : Entity):
	super.get_item(e)
	if !e.on_kill.is_connected(on_kill):
		e.on_kill.connect(on_kill)

func on_kill(a : Entity, t : Entity, dmg : float, proc : float):
	if WorldTime.get_moon():
		if a is Player:
			a.charge += 5 + 2.5 * (stack - 1)

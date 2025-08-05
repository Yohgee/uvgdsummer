extends Item
class_name CelestialStone

func get_item(e : Entity):
	super.get_item(e)
	if !e.on_kill.is_connected(on_kill):
		e.on_kill.connect(on_kill)

func on_kill(a : Entity, t : Entity, dmg : float, proc : float):
	if a is Player:
		var r := randf()
		if r <= (0.01 + 0.01 * (stack- 1)) * proc:
			WorldTime.eclipse = true

extends Item
class_name FlightRegen

@export var regen_amt : float = 0.3

func get_item(e : Entity):
	super.get_item(e)
	if !e.on_hit.is_connected(on_hit):
		e.on_hit.connect(on_hit)

func on_hit(a : Entity, t : Entity, dmg : float, proc : float):
	if a is Player:
		var r := randf()
		if r <= (0.15 + (0.1 * (stack - 1))) * proc:
			a.flight += (regen_amt + 0.2 * (stack - 1)) * proc

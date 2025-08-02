extends Item
class_name FlightRegen

@export var regen_amt : float = 0.5

func get_item(e : Entity):
	e.on_hit.connect(on_hit)

func on_hit(a : Entity, t : Entity, dmg : float, proc : float):
	if a is Player:
		a.flight += regen_amt

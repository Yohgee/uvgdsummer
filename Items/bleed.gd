extends Item
class_name BleedEffect

var tick_timer : float = 0
var end_timer : float = 0

func get_item(e : Entity):
	super.get_item(e)
	end_timer = 0

func tick(e : Entity, delta : float):
	tick_timer += delta
	end_timer += delta
	if tick_timer >= 0.75:
		tick_timer = 0
		e.take_damage(null, e.max_health * (0.02 + 0.01 * (stack - 1)), 0)
	if end_timer >= 3:
		end_timer = 0
		stack = 1
		e.remove_item(self)

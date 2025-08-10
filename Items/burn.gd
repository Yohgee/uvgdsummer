extends Item
class_name BurnEffect

var tick_timer : float = 0
var end_timer : float = 0
var mult : float = 1

func get_item(e : Entity):
	super.get_item(e)
	end_timer = 0

func tick(e : Entity, delta : float):
	tick_timer += delta
	end_timer += delta
	if tick_timer >= 1:
		tick_timer = 0
		e.take_damage(null, 4 * stack * mult, 0)
	if end_timer >= 4:
		end_timer = 0
		stack = 1
		e.remove_item(self)

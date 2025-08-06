extends Item
class_name Chlorophyll

var timer : Timer
var entity : Entity
var base_wait_time : float = 5.0

func get_item(e : Entity):
	super.get_item(e)
	entity = e
	if !timer:
		timer = Timer.new()
		e.add_child(timer)
		timer.wait_time = 5.0
		timer.timeout.connect(on_timer)
		timer.start()

func on_timer():
	if !WorldTime.get_sun(): return
	entity.take_damage(null, -(2 + 1 * (stack - 1)), 0)
	timer.wait_time = clamp(base_wait_time - 0.5 * (stack -1), 0.5, 5)
	

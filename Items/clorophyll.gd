extends Item
class_name Chlorophyll

var timer : Timer
var entity : Entity

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
	entity.take_damage(null, -(2 + 1 * (stack - 1)), 0)
	timer.wait_time = clamp(timer.wait_time - 0.5 * (stack -1), 0.5, 5)

extends Item
class_name SlowEffect

var end_timer : float = 0

func get_item(e : Entity):
	super.get_item(e)
	end_timer = 0
	e.speed_multiplier *= 0.75

func tick(e : Entity, delta : float):
	end_timer += delta
	if end_timer >= 5:
		end_timer = 0
		while stack > 0:
			e.speed_multiplier /= 0.75
			stack -= 1
			print(stack)
			print(e.speed_multiplier)
		e.remove_item(self)

extends Item
class_name WandScope

func get_item(e : Entity):
	super.get_item(e)
	if e is Player:
		e.attack_speed_mult *= 0.9
		e.bullet_speed += 50
	
func remove_item(e : Entity):
	if e is Player:
		e.attack_speed_mult /= 0.9
		e.bullet_speed -= 50

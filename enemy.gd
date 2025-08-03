extends Entity
class_name Enemy

@export var hp_bar : TextureProgressBar

func set_health(nv):
	var d : float = health - nv
	health = clamp(nv, 0, max_health)
	hp_bar.max_value = max_health
	hp_bar.value = health
	hp_bar.show()
	var dn = DAMAGE_NUM.instantiate()
	dn.damage = d
	get_parent().add_child(dn)
	dn.global_position = global_position + Vector2(randf_range(-16, 16), hp_bar.position.y - 8 + randf_range(-8, 8))

func die(attacker : Entity, damage : float, proc : float):
	if attacker is Player:
		print("hi")
	super.die(attacker, damage, proc)

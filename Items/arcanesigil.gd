extends Item
class_name ArcaneSigil

const HOMINGBULLET = preload("res://Items/homingbullet.tscn")

func get_item(e : Entity):
	super.get_item(e)
	if !e.on_hit.is_connected(on_hit):
		e.on_hit.connect(on_hit)

func on_hit(a : Entity, t : Entity, dmg : float, proc : float):
	if !WorldTime.get_moon(): return
	if a is Player:
		var r := randf()
		if r <= 0.20 * proc:
			var bullet : Bullet = HOMINGBULLET.instantiate()
			var angle := a.get_angle_to(a.get_global_mouse_position())
			var offset := Vector2(16, 0).rotated(angle)
			var w : World = a.get_tree().get_first_node_in_group("world")
			bullet.shooter = a
			w.stratum.call_deferred("add_child", bullet)
			
			bullet.damage = dmg * (2 + 0.5 * (stack - 1))
			var p = a.get("bullet_pierce")
			var p_p = 0
			if p:
				p_p += p
			bullet.pierce += p_p
			bullet.rotation = angle
			bullet.global_position = a.global_position + offset
			bullet.velocity = Vector2(900, 0).rotated(angle)
			bullet.hit.connect(a.get_hit)

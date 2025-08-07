extends Item
class_name GiantSnowball

const SNOWBUILLET = preload("res://Items/snowbuillet.tscn")

func get_item(e : Entity):
	super.get_item(e)
	if !e.on_hit.is_connected(on_hit):
		e.on_hit.connect(on_hit)

func on_hit(a : Entity, t : Entity, dmg : float, proc : float):
	if a is Player:
		var r := randf()
		if r <= (0.15 + (0.01 * (stack - 1))) * proc * 100:
			var angle := a.get_angle_to(a.get_global_mouse_position())
			var offset := Vector2(16, 0).rotated(angle)
			var bullet : Bullet = SNOWBUILLET.instantiate()
			var w : World = a.get_tree().get_first_node_in_group("world")
			w.stratum.call_deferred("add_child", bullet)
			bullet.shooter = a
			bullet.damage = dmg * (0.5 + 0.2 * (stack-1))
			bullet.pierce = a.bullet_pierce
			bullet.rotation = angle
			bullet.global_position = a.global_position + offset
			bullet.velocity = Vector2(a.bullet_speed - 100, 0).rotated(angle)
			bullet.hit.connect(a.get_hit)
			bullet.hit.connect(apply_slow)

func apply_slow(a : Entity, t : Entity, dmg : float, proc : float):
	pass

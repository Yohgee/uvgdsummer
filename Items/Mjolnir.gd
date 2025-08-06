extends Item
class_name Mjolnir

const LIGHTNING = preload("res://Items/lightning.tscn")

func get_item(e : Entity):
	super.get_item(e)
	if !e.on_hit.is_connected(on_hit):
		e.on_hit.connect(on_hit)

func on_hit(a : Entity, t : Entity, dmg : float, proc : float):
	if a is Player:
		var r := randf()
		if r <= 0.25 * proc:
			var bullet : Bullet = LIGHTNING.instantiate()
			var w : World = a.get_tree().get_first_node_in_group("world")
			w.stratum.call_deferred("add_child", bullet)
			bullet.shooter = a
			bullet.damage = dmg * (4 + (stack - 1))
			var p = a.get("bullet_pierce")
			var p_p = 0
			if p:
				p_p += p
			bullet.pierce += p_p
			bullet.global_position = t.global_position + Vector2(0, -40)
			bullet.velocity = Vector2(0, 1000)
			bullet.hit.connect(a.get_hit)

extends Item
class_name Supernova

const SPREAD_SHOOTER = preload("res://Shooters/spread_shooter.tscn")

@export var spread_res : SpreadRes
@export var bulres : BulletRes

func get_item(e : Entity):
	super.get_item(e)
	if !e.on_kill.is_connected(on_kill):
		e.on_kill.connect(on_kill)

func on_kill(a : Entity, t : Entity, dmg : float, proc : float):
	dmg = clamp(dmg, 10, 10000)
	if WorldTime.get_sun():
		bulres.damage = dmg * (1 + 0.5 * (stack - 1))
		if a is Player:
			bulres.pierce = a.bullet_pierce
			bulres.velocity.x = a.bullet_speed
		var shoota = SPREAD_SHOOTER.instantiate()
		shoota.shooter = a
		spread_res.apply(shoota)
		shoota.spawn_res = bulres
		shoota.spawn_num = 2**(clamp(stack + 1, 2, 4))
		var w : World = a.get_tree().get_first_node_in_group("world")
		w.stratum.call_deferred("add_child", shoota)
		shoota.global_position = t.global_position

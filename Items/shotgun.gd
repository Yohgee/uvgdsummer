extends Item
class_name Shotgun

const SPREAD_SHOOTER = preload("res://Shooters/spread_shooter.tscn")

@export var spread_res : SpreadRes
@export var bulres : BulletRes

func get_item(e : Entity):
	super.get_item(e)
	if !e.on_block.is_connected(on_block):
		e.on_block.connect(on_block)

func on_block(e : Entity):
	if e is Player:
		var angle := e.get_angle_to(e.get_global_mouse_position())
		var offset := Vector2(16, 0).rotated(angle)
		bulres.pierce = e.bullet_pierce
		bulres.damage = 10 + 5 * (stack - 1)
		bulres.velocity.x = e.bullet_speed
		var shoota = SPREAD_SHOOTER.instantiate()
		shoota.shooter = e
		shoota.spread_angle = 30 + 10 * clamp(stack - 1, 0, 6)
		spread_res.apply(shoota)
		shoota.spawn_res = bulres
		shoota.spawn_num = 3 + 2 * (clamp(stack - 1, 0, 6))
		var w : World = e.get_tree().get_first_node_in_group("world")
		w.stratum.call_deferred("add_child", shoota)
		shoota.global_position = e.global_position + offset
		shoota.rotation = angle

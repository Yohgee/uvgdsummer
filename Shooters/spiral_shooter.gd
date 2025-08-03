extends Shooter
class_name SpiralShooter

@export var rot_per_shot : float = 15.0

func shoot():
	if !spawn_node: return
	
	var node : Node2D = spawn_node.instantiate()
	if shooter:
		node.shooter = shooter
	if spawn_res:
		var vel = spawn_res.get("velocity")
		var accel = spawn_res.get("acceleration")
		if vel:
			spawn_res.set("velocity", vel.rotated(rotation))
		if accel and !fix_accel:
			spawn_res.set("acceleration", accel.rotated(rotation))
				
		spawn_res.call("apply", node)
		spawn_res.set("velocity", vel)
		spawn_res.set("acceleration", accel)
	
	get_tree().current_scene.add_child(node)
	node.global_position = global_position + offset.rotated(rotation)
	
	rotation_degrees += rot_per_shot
	
	if num_shots == -1: return
	num_shots -= 1
	if num_shots <=0:
		queue_free()

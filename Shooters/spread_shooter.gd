extends Shooter
class_name SpreadShooter

@export var spread_angle : float = 45
@export var spawn_num : int = 3

func shoot():
	if !spawn_node: return
	
	
	
	if aimed:
		var p : Player = get_tree().get_first_node_in_group("player")
		look_at(p.global_position)
	
	var i_rot : float = rotation
	
	rotation_degrees -= spread_angle/2
	var dr : float = spread_angle/(spawn_num - 1)
	if spread_angle == 360:
		dr = spread_angle/(spawn_num)
	
	for i in spawn_num:
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
		node.rotation = rotation
		
		rotation_degrees += dr
	rotation = i_rot
	if num_shots == -1: return
	num_shots -= 1
	if num_shots <= 0:
		queue_free()

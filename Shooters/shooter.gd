extends Node2D
class_name Shooter

@export var spawn_node : PackedScene
@export var spawn_res : BHRes
@export var shooter : Entity
@export var start_delay : float
@export var spawn_delay : float
@export var velocity : Vector2
@export var acceleration : Vector2
@export var fix_accel : bool = false
@export var offset : Vector2
@export var aimed : bool = false
@export var num_shots : int = -1
@export var carry_node : PackedScene
@export var carry_res : BHRes

var timer : Timer
var carry : Node2D

func _ready() -> void:
	if carry_node:
		carry = carry_node.instantiate()
		carry.shooter = shooter
		if carry_res:
			carry_res.call("apply", carry)
		add_child(carry)
	
	if spawn_delay <= 0: return
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = spawn_delay
	timer.timeout.connect(shoot)
	if start_delay > 0:
		await get_tree().create_timer(start_delay).timeout
	timer.start()

func _physics_process(delta: float) -> void:
	position += velocity * delta
	velocity += acceleration * delta
	if carry_node and !carry:
		queue_free()

func shoot():
	if !spawn_node: return
	
	if aimed:
		var p : Player = get_tree().get_first_node_in_group("player")
		look_at(p.global_position)
	
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
	if num_shots == -1: return
	num_shots -= 1
	if num_shots <=0:
		queue_free()

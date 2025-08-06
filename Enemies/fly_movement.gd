extends Node2D
class_name FlyMovement

@export var entity : Entity
@export var shooters : Array[Shooter]
@export var range : float = 300
@export var range_diff : float = 100
@export var sin_ratio := 0.6
@export var rand_ratio := 0.2
@export var follow_accel := 0.2
@export var stay_accel := 0.1

@onready var player : Player = get_tree().get_first_node_in_group("player")

var osc : float = randf_range(0, 2 * PI)
var rand_vel := Vector2.ZERO

func _ready() -> void:
	for s in shooters:
		s.timer.stop()
	range += randf_range(-range_diff, range_diff)

func _physics_process(delta: float) -> void:
	var d := global_position.distance_to(player.global_position)
	osc = wrapf(osc + delta * 3, 0, 2 * PI)
	if d > range:
		var new_vel := Vector2(entity.base_speed * entity.speed_multiplier, 0).rotated(global_position.direction_to(player.global_position).angle())
		new_vel.y += sin(osc) * entity.base_speed * entity.speed_multiplier * sin_ratio
		var d_v := new_vel - entity.velocity
		entity.velocity += d_v * follow_accel
	else:
		for s in shooters:
			if s.timer.is_stopped():
				s.timer.start()
		if randf() <= 0.01 and osc > PI:
			rand_vel = Vector2(randf_range(-entity.base_speed * entity.speed_multiplier * rand_ratio, entity.base_speed * entity.speed_multiplier * rand_ratio), randf_range(-entity.base_speed * entity.speed_multiplier * rand_ratio, entity.base_speed * entity.speed_multiplier * rand_ratio))
		var new_vel := Vector2(rand_vel.x, sin(osc) * entity.base_speed * entity.speed_multiplier * sin_ratio + rand_vel.y)
		var d_v := new_vel - entity.velocity
		entity.velocity += d_v * stay_accel
	
	
	entity.move_and_slide()

extends Area2D
class_name Homer

@export var bullet : Bullet
var target : Enemy
var target_q : Array[Enemy]

func _ready() -> void:
	bullet.hit.connect(new_target)

func _physics_process(delta: float) -> void:
	if !target: return
	var speed = bullet.velocity.length()
	var angle : float = bullet.global_position.direction_to(target.global_position).angle()
	bullet.velocity = Vector2(speed, 0).rotated(angle)

func new_target(t : Entity, dmg : float, procc : float):
	target = null
	if !target_q.is_empty():
		target = target_q.pop_front()

func _on_body_entered(body: Node2D) -> void:
	if body == bullet.shooter: return
	if body is not Enemy: return
	if target: 
		target_q.append(body)
		return
	target = body

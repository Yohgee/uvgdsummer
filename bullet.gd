extends Area2D
class_name Bullet

signal hit(target : Entity, dmg : float, procc : float)

@export var damage : float = 10
@export var proc : float = 1.0
@export var lifetime : float = 10
@export var pierce : int = 1
@export var rotate_to_vel : bool = false

var velocity : Vector2 = Vector2.ZERO
var acceleration : Vector2 = Vector2.ZERO
var shooter : Entity
var dm : float = 1

func _ready() -> void:
	if !body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if shooter:
		dm = shooter.damage_mult

func _process(delta: float) -> void:
	position += velocity * delta
	velocity += acceleration * delta
	if rotate_to_vel:
		rotation = velocity.angle()
	lifetime -= delta
	if lifetime <= 0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body == shooter: 
		return
	
	if body.collision_layer == 2 and body is Entity:
		if shooter:
			if shooter is not Player and body is not Player: return
		else:
			if body is not Player: return
		
		body = body as Entity
		hit.emit(body, damage, proc)
		if shooter:
			body.take_damage(shooter, damage * dm , proc)
		else:
			body.take_damage(null, damage * dm, proc)
		pierce -= 1
		if pierce > 0: return
	
	queue_free()

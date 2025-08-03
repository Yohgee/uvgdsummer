extends Area2D
class_name Bullet

signal hit(target : Entity, dmg : float, procc : float)

@export var damage : float = 10
@export var proc : float = 1.0
@export var lifetime : float = 10

var velocity : Vector2 = Vector2.ZERO
var shooter : Entity

func _ready() -> void:
	if !body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	position += velocity * delta
	lifetime -= delta
	if lifetime <= 0:
		print(lifetime)
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body == shooter: 
		return
	
	if body.collision_layer == 2 and body is Entity:
		body = body as Entity
		hit.emit(body, damage, proc)
		body.take_damage(shooter, damage, proc)
	
	queue_free()

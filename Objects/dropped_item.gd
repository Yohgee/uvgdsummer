extends CharacterBody2D
class_name DroppedItem

@export var item : Item
@onready var sprite_2d: Sprite2D = $Sprite2D

var p : Player

func _ready() -> void:
	sprite_2d.texture = item.texture

func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	move_and_slide()
	if p:
		if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("down"):
			p.get_item(item)
			queue_free()
	if is_on_floor():
		velocity = Vector2.ZERO


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not Player: return
	if !is_on_floor(): return
	
	p = body as Player


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is not Player: return
	p = null

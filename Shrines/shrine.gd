extends Area2D
class_name Shrine

@export var interact_component : Node2D
@export var text : String
@onready var flavour_text: Label = $CollisionShape2D/FlavourText

var p : Player = null

func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exit)
	flavour_text.text = text

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and p:
		if interact_component:
			interact_component.call("interact", p)

func on_body_entered(body : Node2D):
	if body is Player:
		p = body
		flavour_text.show()

func on_body_exit(body : Node2D):
	if body is Player:
		p = null
		flavour_text.hide()

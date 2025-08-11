extends Node2D
class_name DamageNum

var damage : float = 10

@onready var label: Label = $Label
@onready var hit: AudioStreamPlayer = $hit

var time = 0.2

func _ready() -> void:
	if damage < 0:
		label.modulate = Color.AQUAMARINE
		hit.play()
	damage = abs(damage)
	label.text = "%.1f" % damage

func _process(delta: float) -> void:
	time -= delta
	position.y -= delta * 16
	modulate.a -= delta * 4
	if time <= 0:
		queue_free()

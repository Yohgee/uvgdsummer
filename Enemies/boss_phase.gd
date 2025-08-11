extends Node2D
class_name BossPhase

var shooter : Entity

func _ready() -> void:
	for c in get_children():
		if c is Shooter:
			c.shooter = shooter

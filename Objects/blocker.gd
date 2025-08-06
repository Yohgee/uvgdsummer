extends Area2D

@export var player : Player

func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		if area.shooter == player: return
		area.queue_free()

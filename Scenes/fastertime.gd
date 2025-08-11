extends Marker2D

func _process(delta: float) -> void:
	WorldTime.add_time(delta * 4)

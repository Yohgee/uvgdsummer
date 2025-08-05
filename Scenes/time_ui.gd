extends Control
class_name TimeUI

@onready var sun_spr: Sprite2D = $SunSpr
@onready var moon_spr: Sprite2D = $MoonSpr
@export var label: Label

func _process(delta: float) -> void:
	sun_spr.visible = WorldTime.get_sun()
	moon_spr.visible = WorldTime.get_moon()
	rotation_degrees = WorldTime.time * 3
	if WorldTime.eclipse:
		label.text = "Eclipse"
	elif WorldTime.get_sun():
		label.text = "Day"
	else:
		label.text = "Night"

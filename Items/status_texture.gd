extends TextureRect
class_name StatusContainerUI

@export var i : Item

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $Label

func _ready() -> void:
	sprite_2d.texture = i.texture
	label.hide()

func get_item():
	print(i.stack)
	if i.stack > 1:
		label.show()
		label.text = "x" + str(i.stack)

func remove_item():
	if i.stack <= 0:
		queue_free()

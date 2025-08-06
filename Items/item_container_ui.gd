extends TextureRect
class_name ItemContainerUI

@export var i : Item

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var desc: Label = $ColorRect/desc
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	sprite_2d.texture = i.texture
	label.hide()
	desc.text = i.desc

func get_item():
	if i.stack > 1:
		label.show()
		label.text = "x" + str(i.stack)

func remove_item():
	if i.stack <= 0:
		queue_free()


func _on_mouse_entered() -> void:
	color_rect.show()


func _on_mouse_exited() -> void:
	color_rect.hide()

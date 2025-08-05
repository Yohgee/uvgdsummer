extends Control
class_name ItemDisplay

var q : Array[Item]
var t : float = 0.0
var display_time := 0.8
@onready var desc: Label = $ColorRect/Desc
@onready var label: Label = $ColorRect/Label
@onready var sprite_2d: Sprite2D = $ColorRect/Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func add_item_to_q(i : Item):
	q.append(i)
	if q.size() == 1:
		display_item()

func display_item():
	var i : Item = q[0]
	sprite_2d.texture = i.texture
	label.text = i.name
	desc.text = i.desc
	animation_player.play("fade_items")
	await animation_player.animation_finished
	i = q.pop_front()
	if !q.is_empty():
		display_item()

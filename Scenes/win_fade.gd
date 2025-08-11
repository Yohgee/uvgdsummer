extends ColorRect
class_name WinFade

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func win():
	animation_player.play("fade")
	await  animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/winner.tscn")

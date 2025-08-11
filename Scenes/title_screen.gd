extends Control

@onready var easy: Button = $VBoxContainer/HBoxContainer/Easy
@onready var medium: Button = $VBoxContainer/HBoxContainer/Medium
@onready var hard: Button = $VBoxContainer/HBoxContainer/HARD
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var tutorial: Sprite2D = $Tutorial
@onready var creds: Label = $Creds

func _ready() -> void:
	change_diff(medium, 1.0)

func change_diff(b : Button, d : float):
	WorldTime.diff_mult = d
	easy.modulate = Color.DIM_GRAY
	medium.modulate = Color.DIM_GRAY
	hard.modulate = Color.DIM_GRAY
	b.modulate = Color.WHITE

func _on_easy_pressed() -> void:
	change_diff(easy, 0.5)

func _on_medium_pressed() -> void:
	change_diff(medium, 1.0)

func _on_hard_pressed() -> void:
	change_diff(hard, 1.5)


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
	audio_stream_player.play()


func _on_tutorial_pressed() -> void:
	tutorial.show()
	creds.hide()


func _on_credits_pressed() -> void:
	tutorial.hide()
	creds.show()


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

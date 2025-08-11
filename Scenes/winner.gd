extends Control

@onready var dealt: Label = $dealt
@onready var taken: Label = $taken
@onready var collect: Label = $collect
@onready var kills: Label = $kills
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	dealt.text = "You dealt %.1f damage." % WorldTime.damage_dealt
	taken.text = "You took %.1f damage." % WorldTime.damage_taken
	collect.text = "You collected " + str(WorldTime.items_collected) + " items."
	kills.text = "You killed " + str(WorldTime.enemies_killed) + " enemies."
	animation_player.play("fadewaayt")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")

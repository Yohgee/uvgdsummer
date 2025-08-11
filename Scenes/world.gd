extends Node2D
class_name World

var level : int = 0
@export var strata : Array[PackedScene]
var stratum : Stratum
@onready var player: Player = $Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	change_stratum()

func change_stratum():
	if stratum:
		stratum.queue_free()
	player.position = Vector2.ZERO
	stratum = strata[wrapi(level, 0, 6)].instantiate()
	stratum.world = self
	add_child(stratum)

func _process(delta: float) -> void:
	if !WorldTime.eclipse:
		WorldTime.add_time(delta)
	else:
		WorldTime.add_time(delta * 2)
	if Input.is_action_just_pressed("test"):
		pass

func next_level():
	for c in get_children():
		if c is Enemy or c is Bullet or c is Shooter:
			c.queue_free()
	stratum.cleanse()
	level += 1
	animation_player.play("level_fade")
	await animation_player.animation_finished
	player.health = player.max_health
	change_stratum()
	animation_player.play("level_fade_out")
	


func _on_player_on_death(attacker: Entity, target: Entity, damage: float, proc: float) -> void:
	animation_player.play("level_fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")

extends Node2D
class_name Stairs

@export var stair_speed = 40
var active : bool = false
@export var time_left : float = 60.0

@onready var sprite_2d: Sprite2D = $"../CollisionShape2D/Sprite2D"
@onready var label: Label = $CanvasLayer/Label
@onready var parent : Shrine = get_parent()

@export var spawner : EnemySpawnShrine
@export var di : DropItem
@export var peak = false

signal finish_level

func _ready() -> void:
	var world : World = get_tree().get_first_node_in_group("world") as World
	finish_level.connect(world.next_level)

func interact(p : Player):
	if !active and time_left > 0:
		if spawner:
			spawner.start_spawn()
		if di:
			di.drop_item()
		label.show()
		active = true
		parent.flavour_text.text = ""
		return
	if active and time_left > 0:
		return
	finish_level.emit()

func down_interact(p : Player):
	if active or time_left > 0:
		return
	var world : World = get_tree().get_first_node_in_group("world") as World
	world.level += 1
	finish_level.emit()

func _process(delta: float) -> void:
	if !active: return
	time_left -= delta
	label.text = "Time Left: " + str(int(round(time_left)))
	if time_left <= 0:
		active = false
		parent.flavour_text.text = "Climb to the next stratum."
		if peak:
			parent.flavour_text.text = "Press E to go to the moon. \n Press Down to Loop."
	sprite_2d.region_rect.size.y += delta * stair_speed
	sprite_2d.position.y -= delta * (stair_speed/2)
	

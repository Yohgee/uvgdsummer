extends Node2D
class_name Stairs

const  stair_speed = 40
var active : bool = false
var time_left : float = 60.0

@onready var sprite_2d: Sprite2D = $"../CollisionShape2D/Sprite2D"
@onready var label: Label = $CanvasLayer/Label

@export var spawner : EnemySpawnShrine
@export var di : DropItem

signal finish_level

func _ready() -> void:
	var world : World = get_tree().get_first_node_in_group("world") as World
	finish_level.connect(world.next_level)

func interact(p : Player):
	if !active and time_left > 0:
		spawner.start_spawn()
		di.drop_item()
		label.show()
		active = true
		return
	if active and time_left > 0:
		return
	finish_level.emit()
	

func _process(delta: float) -> void:
	if !active: return
	time_left -= delta
	label.text = "Time Left: " + str(int(round(time_left)))
	if time_left <= 0:
		active = false
	sprite_2d.region_rect.size.y += delta * stair_speed
	sprite_2d.position.y -= delta * (stair_speed/2)
	

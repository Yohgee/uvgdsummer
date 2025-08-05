extends Node2D
class_name Stratum

@export var level : int = 0
@export var level_name : String = "Foundation"

@export var room_width : int = 1280
@export var room_height : int = 720
@export var rooms : Array[PackedScene]

@export var stratum_width : int = 2
@export var stratum_height : int = 3

@export var border_colour : Color = Color.ALICE_BLUE

@onready var right: StaticBody2D = $Right
@onready var border: Line2D = $Border
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var name_label: Label = $CanvasLayer/Control/NameLabel

func _ready() -> void:
	name_label.text = "Stratum " + str(level) + ": " + level_name
	border.default_color = border_colour
	border.add_point(Vector2(0, -(room_height * (stratum_height + 1))))
	border.add_point(Vector2(0, 0))
	border.add_point(Vector2(room_width * stratum_width, 0))
	border.add_point(Vector2(room_width * stratum_width, -(room_height * (stratum_height + 1))))
	
	right.position.x = room_width * stratum_width
	var pos : Vector2 = Vector2(room_width/2, -room_height/2)
	var stair_room : int = randi_range(0, stratum_width - 1)
	rooms.shuffle()
	for y in stratum_height:
		for x in stratum_width:
			
			var r : Room = rooms.pop_front().instantiate()
			add_child(r)
			r.position = pos
			if y == stratum_height - 1 and x == stair_room:
				r.generate_stairs()
			
			r.generate_shrines()
			
			pos.x += room_width
		pos.x -= room_width * stratum_width
		pos.y -= room_height
	
	animation_player.play("name_fade")

func cleanse():
	for c in get_children():
		if c is Bullet or c is Enemy or c is Shooter:
			c.queue_free()

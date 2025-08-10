extends Node2D
class_name Stratum

@export var level : int = 0
@export var level_name : String = "Foundation"

@export_category("Level Generation")

@export var room_width : int = 1280
@export var room_height : int = 720
@export var rooms : Array[PackedScene]

@export var stratum_width : int = 2
@export var stratum_height : int = 3

@export var border_colour : Color = Color.ALICE_BLUE

@export_category("Enemy Spawning")

@export var sun_enemies : Array[PackedScene]
@export var sun_credits : Array[int]
@export var moon_enemies : Array[PackedScene]
@export var moon_credits : Array[int]

@onready var right: StaticBody2D = $Right
@onready var border: Line2D = $Border
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var name_label: Label = $CanvasLayer/Control/NameLabel

var world : World
var spawn_credits : int = 30
var wave_timer : Timer
@export var max_wave_time : float = 30
@export var min_wave_time : float = 15

func _ready() -> void:
	name_label.text = "Stratum " + str(level) + ": " + level_name
	rooms = rooms.duplicate()
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
	
	wave_timer = Timer.new()
	add_child(wave_timer)
	wave_timer.start(randf_range(min_wave_time/2, max_wave_time/2))
	wave_timer.timeout.connect(spawn_wave)
	spawn_credits += world.level * 10
	animation_player.play("name_fade")

func spawn_wave():
	wave_timer.stop()
	var ms : int = sun_credits.min()
	var mm : int = moon_credits.min()
	
	while (spawn_credits >= ms and WorldTime.get_sun()) or (spawn_credits >= mm and WorldTime.get_moon()):
		var sunspawn : int = randi_range(0, sun_enemies.size()-1)
		if spawn_credits >= sun_credits[sunspawn] and WorldTime.get_sun():
			spawn_enemy(sun_enemies[sunspawn])
			spawn_credits -= sun_credits[sunspawn]
		var moonspawn : int = randi_range(0, moon_enemies.size()-1)
		if spawn_credits >= moon_credits[moonspawn] and WorldTime.get_moon():
			spawn_enemy(moon_enemies[moonspawn])
			spawn_credits -= moon_credits[moonspawn]
	
	var new_time :=randf_range(min_wave_time - clamp(world.level, 0, 7), max_wave_time- clamp(floor(world.level * 0.5), 0, 7))
	spawn_credits += 30 + world.level * 10
	if WorldTime.eclipse:
		spawn_credits *= 1.5
		new_time *= 0.5
	wave_timer.start(new_time)

func spawn_enemy(s : PackedScene):
	var p : Player = get_tree().get_first_node_in_group("player")
	var e : Entity = s.instantiate()
	e.set("level", world.level)
	add_child(e)
	e.global_position = p.global_position + Vector2(0, -500 + randf_range(-200, 100)).rotated(randf_range(-PI/2, PI/2))

func cleanse():
	for c in get_children():
		if c is Bullet or c is Enemy or c is Shooter:
			c.queue_free()

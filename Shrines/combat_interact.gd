extends Node2D

@export var uses := 1
@export var di : DropItem
@export var main_enemy : Array[PackedScene]
@export var adds : Array[PackedScene]
@export var spawn_radius := 300
@export var radius_var := 100
@export var min_add : int = 2
@export var max_add : int = 5

func _ready() -> void:
	main_enemy = main_enemy.duplicate()

func interact(p : Player):
	if uses <= 0:
		return
	uses -= 1
	di.drop_item()
	main_enemy.shuffle()
	spawn_enemy(main_enemy.pop_front())
	for i in randi_range(min_add, max_add):
		spawn_enemy(adds[randi_range(0, adds.size()-1)])

func spawn_enemy(s : PackedScene):
	var w : World = get_tree().get_first_node_in_group("world")
	var e : Entity = s.instantiate()
	var offset := Vector2(0, -spawn_radius + randi_range(-radius_var, radius_var)).rotated(randf_range(-PI/2, PI/2))
	w.stratum.add_child(e)
	e.global_position = global_position + offset

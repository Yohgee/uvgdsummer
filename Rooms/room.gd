extends Node2D
class_name Room

@onready var generation_points: Node2D = $GenerationPoints

@export var structures : Array[StructureRes]
@export var struct_spawn_ratio : float = 0.3
const STAIRS = preload("res://Shrines/stairs.tscn")

var gp : Array[Node2D]

func _ready() -> void:
	for c in generation_points.get_children():
		if c is Node2D:
			gp.append(c)
	gp.shuffle()

func generate_stairs():
	var p : Node2D = gp.pop_front()
	var stairs : Shrine = STAIRS.instantiate()
	add_child(stairs)
	stairs.position = p.position

func generate_shrines():
	var shrine_count : int = randi_range(0, floor(gp.size() * struct_spawn_ratio))
	
	var struct_weights : int = 0
	for r in structures:
		struct_weights += r.weight
	
	for i in shrine_count:
		var rand = randi_range(0, struct_weights)
		for j in structures.size():
			if rand <= structures[j].weight:
				place_structure(structures[j], gp.pop_front())
				break
			rand -= structures[j].weight

func place_structure(s : StructureRes, p : Node2D):
	var struct : Shrine = s.struct.instantiate()
	add_child(struct)
	struct.position = p.position

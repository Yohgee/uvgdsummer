extends CharacterBody2D
class_name Entity

signal on_hit(attacker : Entity, target : Entity, damage : float, proc : float)
@export var items : Array[Item] = []
@export var base_speed := 200
@export var max_health := 100: set = set_max_health

var speed_multiplier : float = 1.0

@onready var health = max_health: set = set_health

func _ready() -> void:
	for i in items.size():
		get_item(items.pop_front())

func get_item(i : Item):
	print(i)
	i.get_item(self)
	items.append(i)

func remove_item(i : Item):
	i.remove_item(self)
	items.erase(i)

func set_health(nv):
	health = clamp(nv, 0, max_health)

func set_max_health(nv):
	max_health = nv

func get_hit(target : Entity, damage : float, proc : float):
	on_hit.emit(self, target, damage, proc)

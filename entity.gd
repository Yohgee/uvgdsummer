extends CharacterBody2D
class_name Entity

const DAMAGE_NUM = preload("res://Objects/damage_num.tscn")
const DEATHPARTICLES = preload("res://Objects/deathparticles.tscn")
signal on_hit(attacker : Entity, target : Entity, damage : float, proc : float)
signal on_damage(attacker : Entity, target : Entity, damage : float, proc : float)
signal on_death(attacker : Entity, target : Entity, damage : float, proc : float)
signal on_kill(attacker : Entity, target : Entity, damage : float, proc : float)
@export var items : Array[Item] = []
@export var base_speed := 200
@export var max_health := 100: set = set_max_health

var status_effects : Array[Item] = []
var speed_multiplier : float = 1.0

@onready var health = max_health: set = set_health

func _ready() -> void:
	items = items.duplicate()
	for i in items.size():
		get_item(items.pop_front())

func get_item(i : Item):
	print(i)
	i = i.duplicate()
	for t in items:
		if t.name == i.name:
			t.get_item(self)
			return
	i.get_item(self)
	if !i.status_effect:
		items.append(i)
	else:
		for t in status_effects:
			if t.name == i.name:
				t.get_item(self)
				update_status_effects(t, true)
				return
		status_effects.append(i)
		update_status_effects(i, true)

func update_status_effects(_i : Item, _g : bool):
	pass

func remove_item(i : Item):
	for t in items:
		if t.name == i.name:
			t.remove_item(self)
			if t.stack <= 0:
				items.erase(t)
			return
	i.remove_item(self)
	if i.stack <= 0:
		if !i.status_effect:
			update_status_effects(i, false)
			items.erase(i)
		else:
			for t in status_effects:
				if t.name == i.name:
					update_status_effects(t, false)
					if t.stack <= 0:
						status_effects.erase(t)
			return
			update_status_effects(i, false)
			status_effects.erase(i)

func _process(delta: float) -> void:
	for se in status_effects:
		se.tick(self, delta)

func set_health(nv):
	health = clamp(nv, 0, max_health)

func set_max_health(nv):
	max_health = nv

func get_hit(target : Entity, damage : float, proc : float):
	on_hit.emit(self, target, damage, proc)

func take_damage(attacker : Entity, damage : float, proc : float):
	health -= damage
	on_damage.emit(attacker, self, damage, proc)
	if health <= 0:
		if attacker:
			attacker.get_kill(self, damage, proc)
		die(attacker, damage, proc)

func get_kill(target : Entity, damage : float, proc : float):
	on_kill.emit(self, target, damage, proc)

func die(attacker : Entity, damage : float, proc : float):
	on_death.emit(attacker, self, damage, proc)
	var dp = DEATHPARTICLES.instantiate()
	get_tree().current_scene.add_child(dp)
	dp.global_position = global_position
	queue_free()

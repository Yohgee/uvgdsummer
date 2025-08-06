extends Node2D

@export var uses := 2
@export var di : DropItem
@export var spawner : EnemySpawnShrine

@onready var shrine : Shrine = get_parent()

func interact(p : Player):
	if uses <= 0:
		return
	uses -= 1
	if uses == 0:
		shrine.flavour_text.text = ""
	
	var rand := randf()
	if rand <= 0.5:
		di.drop_item()
	elif rand <= 0.75:
		spawner.start_spawn()
	else:
		p.take_damage(null, p.max_health * 0.1, 1.0)

extends Node2D

@export var uses := 1
@export var di : DropItem
@export var spawner : EnemySpawnShrine

@onready var shrine : Shrine = get_parent()

func interact(p : Player):
	if uses <= 0:
		return
	uses -= 1
	if uses == 0:
		shrine.flavour_text.text = ""
	di.drop_item()
	spawner.start_spawn()

extends Node2D

@export var uses := 5
@export var damage : float = 0.1
@export var di : DropItem

@onready var shrine : Shrine = get_parent()

func _ready() -> void:
	shrine.text = "Sacrifice Flesh? (-" + str(int(100 * damage)) + "% hp)"

func interact(p : Player):
	if uses <= 0:
		shrine.flavour_text.text = ""
		return
	uses -= 1
	p.take_damage(null, p.max_health * damage, 1.0)
	di.drop_item()
	

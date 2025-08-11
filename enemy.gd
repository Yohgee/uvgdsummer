extends Entity
class_name Enemy

@export var hp_bar : TextureProgressBar
@export var di : DropItem
@export var statuses : HBoxContainer
var level : int = 0
const STATUS_TEXTURE = preload("res://Items/status_texture.tscn")

func _ready() -> void:
	super._ready()
	max_health *= WorldTime.diff_mult + float(level) * 0.8
	damage_mult = WorldTime.diff_mult + float(level) * 0.4

func set_health(nv):
	var d : float = health - nv
	health = clamp(nv, 0, max_health)
	hp_bar.max_value = max_health
	hp_bar.value = health
	hp_bar.show()
	var dn = DAMAGE_NUM.instantiate()
	dn.damage = d
	get_parent().add_child.call_deferred(dn)
	dn.global_position = global_position + Vector2(randf_range(-16, 16), hp_bar.position.y - 8 + randf_range(-8, 8))

func die(attacker : Entity, damage : float, proc : float):
	#if attacker is Player:
		#pass
	if di:
		di.drop_item()
	super.die(attacker, damage, proc)

func update_status_effects(i : Item, g : bool):
	for c : StatusContainerUI in statuses.get_children():
		if c.i.name == i.name:
			if g:
				c.get_item()
			else:
				c.remove_item()
			return
	var nc := STATUS_TEXTURE.instantiate()
	nc.i = i
	statuses.add_child(nc)

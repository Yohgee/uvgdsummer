extends Resource
class_name Item

@export var name : String
@export_multiline var desc : String

func get_item(e : Entity):
	pass

func remove_item(e : Entity):
	pass

func on_hit(a : Entity, t : Entity, dmg : float, proc : float):
	pass

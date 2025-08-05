extends Resource
class_name Item

@export var name : String
@export_multiline var desc : String
@export var texture : Texture2D

var stack : int = 0

func get_item(e : Entity):
	stack += 1
	print(str(self) + " stack: " + str(stack))

func remove_item(e : Entity):
	stack -= 1

func on_hit(a : Entity, t : Entity, dmg : float, proc : float):
	pass

func on_kill(a : Entity, t : Entity, dmg : float, proc : float):
	pass

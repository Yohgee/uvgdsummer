extends Item
class_name PropertyChanger

@export var value : float = 0.0
@export var property : String

func get_item(e : Entity):
	super.get_item(e)
	var ev = e.get(property)
	if ev:
		e.set(property, ev + value)
	
func remove_item(e : Entity):
	var ev = e.get(property)
	if ev:
		e.set(property, ev - value)

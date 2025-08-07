extends Item
class_name SurgeAbsorber

@export var regen_amt : float = 15

func get_item(e : Entity):
	super.get_item(e)
	if e is Player:
		if !e.on_block.is_connected(on_block):
			e.on_block.connect(on_block)

func on_block(e : Entity):
	e.take_damage(null, -regen_amt - 10 * (stack - 1), 0.0)

extends Node2D
class_name DropItem

const DROPPED_ITEM = preload("res://Objects/dropped_item.tscn")
@export var pool_set : PoolSet

func drop_item():
	var w : World = get_tree().get_first_node_in_group("world")
	var i := DROPPED_ITEM.instantiate()
	var rand := randf()
	var c : float = 0
	for n in pool_set.pools.size():
		c += pool_set.chances[n]
		if rand <= c:
			pool_set.pools[n].item_pool.shuffle()
			i.item = pool_set.pools[n].item_pool[0]
			w.stratum.call_deferred("add_child", i)
			i.global_position = global_position + Vector2(0, randf_range(-64, -32))
			i.velocity = Vector2(randf_range(-50, 50), -150)
			return

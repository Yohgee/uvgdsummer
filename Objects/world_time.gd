extends Node

signal on_time_change

var time : float = 0
var sun : bool = true
var moon : bool = false
var eclipse : bool = false
var diff_mult : float = 1.0

var damage_dealt : float = 0
var damage_taken : float = 0
var items_collected : int = 0
var enemies_killed : int = 0

func reset():
	time = 0
	sun = true
	moon = false
	eclipse = false
	damage_dealt = 0
	damage_taken = 0
	items_collected = 0
	enemies_killed = 0

func get_sun() -> bool:
	return sun or eclipse

func get_moon() -> bool:
	return moon or eclipse

func add_time(v : float):
	var n_t = time + v
	time = wrapf(time + v, 0, 60)
	if n_t != time:
		change_phase()
	
	

func change_phase():
	on_time_change.emit()
	sun = !sun
	moon = !moon
	if randf() <= 0.2 and !eclipse:
		eclipse = true
	else:
		eclipse = false

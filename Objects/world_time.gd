extends Node

signal on_time_change

var time : float = 0
var sun : bool = true
var moon : bool = false
var eclipse : bool = false

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

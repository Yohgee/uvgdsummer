extends Resource
class_name ShooterRes

@export var spawn_node : PackedScene
@export var spawn_res : Resource
#i dont think i need ts anyweays @export var shooter : Entity
@export var start_delay : float
@export var spawn_delay : float
@export var velocity : Vector2
@export var offset : Vector2
@export var aimed : bool = false
@export var carry_node : PackedScene
@export var carry_res : Resource

#this is the best possible way to do this dont question it
func apply(s : Shooter):
	s.spawn_node = spawn_node
	s.spawn_res = spawn_res
	s.start_delay = start_delay
	s.spawn_delay = spawn_delay
	s.velocity = velocity
	s.offset = offset
	s.aimed = aimed
	s.carry_node = carry_node
	s.carry_res = carry_res

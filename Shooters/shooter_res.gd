extends BHRes
class_name ShooterRes

@export var spawn_node : PackedScene
@export var spawn_res : BHRes
#i dont think i need ts anyweays @export var shooter : Entity
@export var start_delay : float
@export var spawn_delay : float
@export var velocity : Vector2
@export var acceleration : Vector2
@export var fix_accel : bool = false
@export var offset : Vector2
@export var aimed : bool = false
@export var num_shots : int = -1
@export var carry_node : PackedScene
@export var carry_res : BHRes

#this is the best possible way to do this dont question it
func apply(s : Shooter):
	s.spawn_node = spawn_node
	s.spawn_res = spawn_res
	s.start_delay = start_delay
	s.spawn_delay = spawn_delay
	s.velocity = velocity
	s.acceleration = acceleration
	s.fix_accel = fix_accel
	s.offset = offset
	s.aimed = aimed
	s.num_shots = num_shots
	s.carry_node = carry_node
	s.carry_res = carry_res

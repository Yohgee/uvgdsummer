extends ShooterRes
class_name SpreadRes

@export var spread_angle : float = 45
@export var spawn_num : int = 3

func apply(s : Shooter):
	super.apply(s)
	s = s as SpreadShooter
	s.spread_angle = spread_angle
	s.spawn_num = spawn_num

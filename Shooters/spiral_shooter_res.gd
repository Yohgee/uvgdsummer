extends ShooterRes
class_name SpiralRes

@export var rot_per_shot : float

func apply(s : Shooter):
	super.apply(s)
	s = s as SpiralShooter
	s.rot_per_shot = rot_per_shot

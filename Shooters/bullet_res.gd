extends BHRes
class_name BulletRes

@export var damage : float = 10
@export var proc := 1.0
@export var lifetime := 10.0
@export var velocity : Vector2
@export var acceleration : Vector2
@export var pierce : int = 1

func apply(b : Bullet):
	b.damage = damage
	b.proc = proc
	b.lifetime = lifetime
	b.velocity = velocity
	b.acceleration = acceleration
	b.pierce = pierce

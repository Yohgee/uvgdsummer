extends Enemy
class_name FinalBoss

signal boss_defeated

@export var phases : Array[PackedScene]
var phase : int = 0
var phase_node : BossPhase = null

var sp : Vector2

var sinx : float = 0
var siny : float = 0

func _ready() -> void:
	super._ready()
	change_phase()
	sp = position

func die(attacker : Entity, damage : float, proc : float):
	phase += 1
	if phase < phases.size():
		change_phase()
		return
	boss_defeated.emit()
	super.die(attacker, damage, proc)

func _physics_process(delta: float) -> void:
	sinx = wrapf(sinx + delta * 1.3, 0, 2 * PI)
	siny = wrapf(siny + delta * 3.7, 0, 2 * PI)
	position = sp + Vector2(sin(sinx) * 50, sin(siny) * 50)

func change_phase():
	health = max_health
	if phase_node:
		phase_node.queue_free()
	await  get_tree().create_timer(0.5)
	phase_node = phases[phase].instantiate()
	phase_node.shooter = self
	add_child(phase_node)

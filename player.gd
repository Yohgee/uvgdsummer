extends Entity
class_name Player

const MAX_FALL = 400
const PLAYER_BULLET = preload("res://Objects/player_bullet.tscn")

@onready var ui: PlayerUI = $player_ui_layer/ui
@onready var wand_spr: Sprite2D = $wand
@onready var attack_timer: Timer = $AttackTimer

@export var max_flight := 1.5:
	set(nv):
		max_flight = nv
		ui.flight_bar.max_value = max_flight

@onready var flight = max_flight:
	set(nv):
		flight = clamp(nv, 0, max_flight)
		ui.flight_bar.value = flight

var gravity = 980
var flight_speed : float = 100
var flight_recharge_mult := 2
var base_attack_speed : float = 0.3
var attack_speed_mult : float = 1.0:
	set(nv):
		attack_speed_mult = clamp(nv, 0.01, 999)
		attack_timer.wait_time = base_attack_speed * attack_speed_mult

var bullet_speed : float = 300

var can_attack := true

func _ready() -> void:
	super._ready()
	health = max_health

func _physics_process(delta: float) -> void:
	
	velocity.x = (Input.get_action_strength("right") - Input.get_action_strength("left")) * base_speed * speed_multiplier
	
	wand_spr.look_at(get_global_mouse_position())
	
	if !is_on_floor():
		velocity.y = clamp(velocity.y + gravity * delta, velocity.y, MAX_FALL)
		if Input.is_action_just_pressed("down"):
			velocity.y = MAX_FALL
	elif !Input.is_action_pressed("up"):
		flight += delta * flight_recharge_mult
	
	if Input.is_action_pressed("up") and flight > 0:
		velocity.y = -flight_speed
		flight -= delta
		
	if Input.is_action_pressed("primary") and can_attack:
		can_attack = false
		wand_spr.show()
		attack_timer.start()
		spawn_bullet()
	
	move_and_slide()

func set_health(nv):
	health = clamp(nv, 0, max_health)
	ui.health_bar.value = health

func set_max_health(nv):
	max_health = nv
	ui.health_bar.max_value = max_health

func spawn_bullet():
	var angle := get_angle_to(get_global_mouse_position())
	var offset := Vector2(16, 0).rotated(angle)
	var bullet : Bullet = PLAYER_BULLET.instantiate()
	get_parent().add_child(bullet)
	bullet.shooter = self
	bullet.global_position = global_position + offset
	bullet.velocity = Vector2(bullet_speed, 0).rotated(angle)
	bullet.hit.connect(get_hit)

func _on_attack_timer_timeout() -> void:
	can_attack = true
	wand_spr.hide()

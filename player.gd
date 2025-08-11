extends Entity
class_name Player

const MAX_FALL = 400
const PLAYER_BULLET = preload("res://Objects/player_bullet.tscn")
const PLAYER_NIGHT_BULLET = preload("res://Objects/player_night_bullet.tscn")
const ITEM_TEXTURE = preload("res://Items/item_texture.tscn")
const STATUS_TEXTURE = preload("res://Items/status_texture.tscn")
signal on_block(blocker : Entity)
@onready var grid_container: GridContainer = $player_ui_layer/ui/GridContainer

@onready var ui: PlayerUI = $player_ui_layer/ui
@onready var wand_spr: Sprite2D = $wand
@onready var attack_timer: Timer = $AttackTimer
@onready var night_attack_timer: Timer = $NightAttackTimer
@onready var item_display: ItemDisplay = $player_ui_layer/ui/ItemDisplay
@onready var nightwand_spr: Sprite2D = $nightwand
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shoot: AudioStreamPlayer = $Shoot
@onready var block: AudioStreamPlayer = $Block

@export var max_flight := 1.5:
	set(nv):
		max_flight = nv
		ui.flight_bar.max_value = max_flight
		ui.flight_bar.get_node("Label").text = "%.1f / " % flight + "%.1f" % max_flight

@onready var flight = max_flight:
	set(nv):
		flight = clamp(nv, 0, max_flight)
		ui.flight_bar.value = flight
		ui.flight_bar.get_node("Label").text = "%.1f / " % flight + "%.1f" % max_flight

var max_charge := 100:
	set(nv):
		max_charge = nv
		ui.charge_bar.max_value = max_charge
		ui.charge_bar.get_node("Label").text = "%.1f / " % charge + "%.1f" % max_charge

var charge = 100:
	set(nv):
		charge = clamp(nv, 0, max_charge)
		ui.charge_bar.value = charge
		ui.charge_bar.get_node("Label").text = "%.1f / " % charge + "%.1f" % max_charge

var charge_gain := 5
var gravity = 980
var flight_speed : float = 125
var flight_recharge_mult := 4
var base_attack_speed : float = 0.3
var attack_speed_mult : float = 1.0:
	set(nv):
		attack_speed_mult = clamp(nv, 0.01, 999)
		attack_timer.wait_time = base_attack_speed * attack_speed_mult
		night_attack_timer.wait_time = base_attack_speed * 0.5 * attack_speed_mult 

var bullet_speed : float = 450
var bullet_pierce : int = 1

var can_attack := true
var can_attack_night := true
var dead = false

func _ready() -> void:
	super._ready()
	health = max_health

func _physics_process(delta: float) -> void:
	if dead: return
	
	velocity.x = (Input.get_action_strength("right") - Input.get_action_strength("left")) * base_speed * speed_multiplier
	
	wand_spr.look_at(get_global_mouse_position())
	nightwand_spr.look_at(get_global_mouse_position())
	
	if !is_on_floor():
		velocity.y = clamp(velocity.y + gravity * delta, velocity.y, MAX_FALL)
		if Input.is_action_just_pressed("down"):
			velocity.y = MAX_FALL
	elif !Input.is_action_pressed("up"):
		flight += delta * flight_recharge_mult
	
	if Input.is_action_pressed("up") and flight > 0:
		velocity.y = -flight_speed
		flight -= delta
		
	if Input.is_action_pressed("primary"):
		if WorldTime.get_sun() and can_attack:
			shoot.play()
			can_attack = false
			wand_spr.show()
			attack_timer.start()
			spawn_bullet(PLAYER_BULLET)
		if WorldTime.get_moon() and can_attack_night:
			shoot.play()
			can_attack_night = false
			nightwand_spr.show()
			night_attack_timer.start()
			spawn_bullet(PLAYER_NIGHT_BULLET)
	if Input.is_action_just_pressed("block") and charge >= 100:
		block.play()
		charge -= 100
		flight = max_flight
		animation_player.play("block")
		on_block.emit(self)
	move_and_slide()

func get_item(i : Item):
	i = super.get_item(i)
	if !i.status_effect:
		WorldTime.items_collected += 1
		item_display.add_item_to_q(i)
		for c : ItemContainerUI in grid_container.get_children():
			if c.i.name == i.name:
				c.get_item()
				return
		var nc : ItemContainerUI = ITEM_TEXTURE.instantiate()
		nc.i = i
		grid_container.add_child(nc)

func set_health(nv):
	var d : float = health - nv
	health = clamp(nv, 0, max_health)
	ui.health_bar.value = health
	ui.health_bar.get_node("Label").text = "%.1f / " % health + "%.1f" % max_health
	var dn = DAMAGE_NUM.instantiate()
	dn.damage = d
	get_parent().call_deferred("add_child", dn)
	dn.global_position = global_position + Vector2(randf_range(-16, 16), -10 + randf_range(-8, 8))

func set_max_health(nv):
	max_health = nv
	ui.health_bar.max_value = max_health
	ui.health_bar.get_node("Label").text = "%.1f / " % health + "%.1f" % max_health

func spawn_bullet(b : PackedScene):
	var angle := get_angle_to(get_global_mouse_position())
	var offset := Vector2(16, 0).rotated(angle)
	var bullet : Bullet = b.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.shooter = self
	bullet.pierce = bullet_pierce
	bullet.global_position = global_position + offset
	bullet.velocity = Vector2(bullet_speed, 0).rotated(angle)
	bullet.hit.connect(get_hit)

func _on_attack_timer_timeout() -> void:
	can_attack = true
	wand_spr.hide()

func get_kill(target : Entity, damage : float, proc : float):
	super.get_kill(target, damage, proc)
	charge += charge_gain
	WorldTime.enemies_killed += 1

func _on_night_attack_timer_timeout() -> void:
	can_attack_night = true
	nightwand_spr.hide()

func die(attacker : Entity, damage : float, proc : float):
	if dead: return
	on_death.emit(attacker, self, damage, proc)
	var dp = DEATHPARTICLES.instantiate()
	get_tree().current_scene.add_child(dp)
	dp.global_position = global_position
	hide()
	dead=true

func update_status_effects(i : Item, g : bool):
	for c : StatusContainerUI in ui.status_effects.get_children():
		if c.i.name == i.name:
			if g:
				c.get_item()
			else:
				c.remove_item()
			return
	var nc := STATUS_TEXTURE.instantiate()
	nc.i = i
	ui.status_effects.add_child(nc)

func get_hit(target : Entity, damage : float, proc : float):
	super.get_hit(target, damage, proc)
	WorldTime.damage_dealt += damage

func take_damage(attacker : Entity, damage : float, proc : float):
	super.take_damage(attacker, damage, proc)
	if damage > 0:
		WorldTime.damage_taken += damage

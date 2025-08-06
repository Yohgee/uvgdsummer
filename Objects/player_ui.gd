extends Control
class_name PlayerUI

@onready var health_bar: TextureProgressBar = $VBoxContainer/HealthBar
@onready var flight_bar: TextureProgressBar = $VBoxContainer/FlightBar
@onready var charge_bar: TextureProgressBar = $VBoxContainer/ChargeBar
@onready var status_effects: HBoxContainer = $StatusEffects

extends StaticBody3D

@export var max_health := 100

signal destroyed

var health: int
var health_tween: Tween

@onready var health_bar: ProgressBar = $HealthBarViewport/HealthBar
@onready var health_bar_helper: Node = $HealthBarViewport/HealthBarHelper

func _ready():
	health = max_health
	health_bar_helper.setup(
		health,
		max_health
	)

func take_damage(amount):
	health = max(0, health - amount)
	health_bar_helper.update_health(health, max_health)
	play_hit_animation()
	
	if health <= 0:
		destroy()

func destroy():
	print("Base destroyed!")
	destroyed.emit()

func play_hit_animation():
	var original_scale = scale
	
	var tween = create_tween()
	tween.tween_property(
		self,
		"scale",
		original_scale * 1.05,
		0.06
	)
	
	tween.tween_property(
		self,
		"scale",
		original_scale,
		0.1
	)

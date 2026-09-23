extends Node3D

@export var bullet_scene: PackedScene
@export var upgrade_cost := 30
@export var push_strength := 1.0
@export var push_distance := 0.5
@export var level1_damage := 1
@export var level2_damage := 2
@export var level1_fire_rate := 1.0
@export var level2_fire_rate := 0.6
@export var level2_range_multiplier := 1.25
@export var level1_bullet_speed := 20.0
@export var level2_bullet_speed := 30.0

var targets: Array[Node3D] = []
var coins := 0
var level := 1
var damage := 1
var bullet_speed := 20.0

func _ready() -> void:
	damage = level1_damage
	$ShootTimer.wait_time = level1_fire_rate
	bullet_speed = level1_bullet_speed

	$DetectionArea/CollisionShape3D.shape = $DetectionArea/CollisionShape3D.shape.duplicate()

	$Visual/BaseVisual/Level2.visible = false
	$Visual/RotatingPart/Level2.visible = false

func _process(_delta):
	targets = targets.filter(is_instance_valid)
	
	if not targets.is_empty():
		var target_position = targets[0].global_position
		var direction = target_position - $Visual/RotatingPart.global_position
		direction.y = 0

		$Visual/RotatingPart.look_at(
			$Visual/RotatingPart.global_position + direction,
			Vector3.UP
		)

func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemies"):
		targets.append(body)
		print("Tower detected:", body.name)

func _on_detection_area_body_exited(body: Node3D) -> void:
	if body in targets:
		targets.erase(body)

func _on_shoot_timer_timeout() -> void:
	targets = targets.filter(is_instance_valid)
	
	if targets.is_empty():
		return
	
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.target = targets[0]
	bullet.shooter = self
	bullet.damage = damage
	bullet.speed = bullet_speed
	bullet.push_strength = push_strength
	bullet.push_distance = push_distance
	$Visual/RotatingPart/Muzzle.look_at(targets[0].global_position, Vector3.UP)
	bullet.global_transform = $Visual/RotatingPart/Muzzle.global_transform

func play_spawn_animation():	
	$Visual.scale = Vector3.ONE * 0.1
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(
		$Visual,
		"scale",
		Vector3.ONE,
		0.5
	)

func play_upgrade_animation():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN)
	
	tween.tween_property(
		$Visual,
		"scale",
		Vector3.ZERO,
		0.15
	)
	
	await tween.finished
	
	# Swap models
	$Visual/BaseVisual/Level1.visible = false
	$Visual/RotatingPart/Level1.visible = false
	
	$Visual/BaseVisual/Level2.visible = true
	$Visual/RotatingPart/Level2.visible = true
	
	# Pop upgraded version back in
	tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(
		$Visual,
		"scale",
		Vector3.ONE,
		0.25
	)
	
	await tween.finished

func upgrade():
	if level >= 2: return
	
	level = 2
	
	damage = level2_damage
	$ShootTimer.wait_time = level2_fire_rate
	bullet_speed = level2_bullet_speed

	var shape = $DetectionArea/CollisionShape3D.shape
	shape.radius *= level2_range_multiplier
	
	await play_upgrade_animation()
	
	$UpgradePlatform.monitoring = false
	$UpgradePlatform.visible = false

func add_coins(amount: int):
	coins += amount
	$CoinPlatform.update_progress_text()

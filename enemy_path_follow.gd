extends PathFollow3D

@export var speed := 3

var knockback_tween: Tween
var being_knocked_back := false

func _ready():
	loop = false

func _process(delta):
	if being_knocked_back:
		return
	
	if get_child_count() == 0:
		return
	
	var enemy = get_child(0)
	
	if not is_instance_valid(enemy):
		return
	
	progress += speed * delta * enemy.speed_multiplier
	
	if progress_ratio >= 1.0:
		reach_base()

func reach_base():
	if get_child_count() == 0:
		return
	
	var enemy = get_child(0)
	
	if not is_instance_valid(enemy):
		return
	
	var base = get_tree().current_scene.get_node("Base")
	base.take_damage(enemy.damage)
	queue_free()

func apply_knockback(distance: float):
	if knockback_tween and knockback_tween.is_valid():
		knockback_tween.kill()
	
	being_knocked_back = true
	
	var target_progress = max(0.0, progress - distance)
	
	knockback_tween = create_tween()
	knockback_tween.set_trans(Tween.TRANS_QUAD)
	knockback_tween.set_ease(Tween.EASE_OUT)
	
	knockback_tween.tween_property(
		self,
		"progress",
		target_progress,
		0.15
	)
	
	await knockback_tween.finished
	
	being_knocked_back = false

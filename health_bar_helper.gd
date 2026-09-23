extends Node

@export var health_bar: ProgressBar
@export var damage_bar: ProgressBar
@export var background_panel: Panel

@export var dynamic_color := false
@export var normal_color := Color.RED
@export var full_health_color := Color.GREEN
@export var low_health_color := Color.RED
@export var damage_color := Color(1.0, 0.9, 0.9, 1.0)
@export var corner_radius := 6

@export var start_visibility := false

var health_tween: Tween
var damage_tween: Tween

var health_fill: StyleBoxFlat
var damage_fill: StyleBoxFlat

var punch_tween: Tween
var original_scale := Vector2.ONE

func setup(current_health: float, max_health: float):
	health_bar.max_value = max_health
	damage_bar.max_value = max_health
	
	health_bar.value = current_health
	damage_bar.value = current_health
	
	original_scale = health_bar.scale
	
	# Make a unique copy so changing one health bar
	# doesn't change every other health bar.
	var original_fill = health_bar.get_theme_stylebox("fill")
	if original_fill is StyleBoxFlat:
		health_fill = original_fill.duplicate()
	else:
		health_fill = StyleBoxFlat.new()
	health_fill.corner_radius_top_left = corner_radius
	health_fill.corner_radius_top_right = corner_radius
	health_fill.corner_radius_bottom_left = corner_radius
	health_fill.corner_radius_bottom_right = corner_radius
	health_bar.add_theme_stylebox_override("fill", health_fill)
	
	var original_damage_fill = damage_bar.get_theme_stylebox("fill")
	if original_damage_fill is StyleBoxFlat:
		damage_fill = original_damage_fill.duplicate()
	else:
		damage_fill = StyleBoxFlat.new()
	damage_fill.bg_color = damage_color
	damage_fill.corner_radius_top_left = corner_radius
	damage_fill.corner_radius_top_right = corner_radius
	damage_fill.corner_radius_bottom_left = corner_radius
	damage_fill.corner_radius_bottom_right = corner_radius
	damage_bar.add_theme_stylebox_override("fill", damage_fill)
	
	update_color(current_health, max_health)
	
	if not start_visibility:
		health_bar.visible = false
		damage_bar.visible = false
		background_panel.visible = false

func update_health(current_health: float, max_health: float):
	if not start_visibility:
		health_bar.visible = true
		damage_bar.visible = true
		background_panel.visible = true
	
	if health_tween and health_tween.is_valid():
		health_tween.kill()
	
	if damage_tween and damage_tween.is_valid():
		damage_tween.kill()
	
	play_punch()
	
	health_tween = create_tween()
	health_tween.set_trans(Tween.TRANS_QUAD)
	health_tween.set_ease(Tween.EASE_OUT)
	
	health_tween.tween_property(
		health_bar,
		"value",
		current_health,
		0.18
	)
	
	damage_tween = create_tween()
	damage_tween.tween_interval(0.3)
	
	damage_tween.set_trans(Tween.TRANS_QUAD)
	damage_tween.set_ease(Tween.EASE_OUT)
	
	damage_tween.tween_property(
		damage_bar,
		"value",
		current_health,
		0.25
	)
	
	update_color(current_health, max_health)

func play_punch():
	if punch_tween and punch_tween.is_valid():
		punch_tween.kill()
	
	health_bar.scale = original_scale
	damage_bar.scale = original_scale
	background_panel.scale = original_scale
	
	punch_tween = create_tween()
	punch_tween.set_trans(Tween.TRANS_BACK)
	punch_tween.set_ease(Tween.EASE_OUT)
	punch_tween.tween_property(
		health_bar,
		"scale",
		original_scale * 1.08,
		0.06
	)
	punch_tween.tween_property(
		health_bar,
		"scale",
		original_scale,
		0.10
	)
	
	punch_tween = create_tween()
	punch_tween.set_trans(Tween.TRANS_BACK)
	punch_tween.set_ease(Tween.EASE_OUT)
	punch_tween.tween_property(
		damage_bar,
		"scale",
		original_scale * 1.08,
		0.06
	)
	punch_tween.tween_property(
		damage_bar,
		"scale",
		original_scale,
		0.10
	)
	
	punch_tween = create_tween()
	punch_tween.set_trans(Tween.TRANS_BACK)
	punch_tween.set_ease(Tween.EASE_OUT)
	punch_tween.tween_property(
		background_panel,
		"scale",
		original_scale * 1.08,
		0.06
	)
	punch_tween.tween_property(
		background_panel,
		"scale",
		original_scale,
		0.10
	)

func update_color(current_health: float, max_health: float):
	if health_fill == null:
		return
	
	if not dynamic_color:
		var color = normal_color
		color.a = 1.0
		health_fill.bg_color = color
		return
	
	var health_ratio = clamp(
		current_health / max_health,
		0.0,
		1.0
	)
	
	var color = low_health_color.lerp(
		full_health_color,
		health_ratio
	)
	
	color.a = 1.0
	health_fill.bg_color = color

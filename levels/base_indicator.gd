extends Control

@export var base: Node
@export var camera: Camera3D

@onready var percent_label: Label = $HBoxContainer/HealthCircle/Percent
@onready var arrow: Label = $HBoxContainer/Arrow

func _ready() -> void:
	await get_tree().process_frame
	arrow.pivot_offset = arrow.size / 2.0

func _process(_delta):
	if not is_instance_valid(base):
		return
	
	var health = float(base.get("health"))
	var max_health = float(base.get("max_health"))
	percent_label.text = str(roundi(health / max_health * 100.0)) + "%"
	
	var screen_position = camera.unproject_position(base.global_position)
	var base_is_visible = (
		not camera.is_position_behind(base.global_position)
		and get_viewport().get_visible_rect().has_point(screen_position)
	)
	if base_is_visible:
		visible = false
		return
	
	visible = true
	
	var viewport_size = get_viewport().get_visible_rect().size
	var center = viewport_size / 2.0
	var direction = screen_position - center
	
	if camera.is_position_behind(base.global_position):
		direction = -direction
	
	if direction.length_squared() < 0.001:
		direction = Vector2.UP
	
	arrow.rotation = direction.angle() - PI
	
	var edge_point = center + direction.normalized() * max(viewport_size.x, viewport_size.y)
	var half_size = size / 2.0
	var min_point = Vector2(half_size.x + 24, half_size.y + 100)
	var max_point = viewport_size - min_point
	edge_point = edge_point.clamp(min_point, max_point)
	
	position = edge_point - half_size

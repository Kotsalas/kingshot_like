extends Camera3D

@export var target: Node3D
@export var follow_speed := 6.0

const FOLLOW_OFFSET := Vector3(8, 14, 8)

func _ready() -> void:
	if target:
		global_position = target.global_position + FOLLOW_OFFSET

func _process(delta):
	if target:
		var target_position = target.global_position + FOLLOW_OFFSET
		var follow_weight = 1.0 - exp(-follow_speed * delta)
		global_position = global_position.lerp(target_position, follow_weight)

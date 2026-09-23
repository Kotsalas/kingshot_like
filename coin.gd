extends Node3D

@export var travel_time := 1.2
@export var arc_height := 1.5

var target: Node3D
var amount := 1
var on_arrival: Callable

var start_position: Vector3
var elapsed := 0.0

func setup_start_position():
	start_position = global_position

func _process(delta):
	if not is_instance_valid(target):
		queue_free()
		return
	
	elapsed += delta
	
	var t = clamp(elapsed / travel_time, 0.0, 1.0)
	
	# Ease in-out
	var eased_t = smoothstep(0.0, 1.0, t)
	
	# Move from giver to receiver
	var position = start_position.lerp(
		target.global_position,
		eased_t
	)
	
	# Arc upward, maximum height at the middle
	var arc = sin(t * PI) * arc_height
	position.y += arc
	
	global_position = position
	
	if t >= 1.0:
		if on_arrival.is_valid():
			on_arrival.call(amount)
		
		queue_free()

func randomize_travel():
	arc_height += randf_range(-0.3, 0.5)
	travel_time += randf_range(-0.05, 0.08)

extends Control

@onready var knob = $Knob

var dragging := false
var input_vector := Vector2.ZERO

func _gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			dragging = true
			update_joystick(event.position)
		else:
			dragging = false
			input_vector = Vector2.ZERO
			reset_knob()

	elif event is InputEventScreenDrag:
		if dragging:
			update_joystick(event.position)

	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				update_joystick(event.position)
			else:
				dragging = false
				input_vector = Vector2.ZERO
				reset_knob()

	elif event is InputEventMouseMotion:
		if dragging:
			update_joystick(event.position)


func update_joystick(position: Vector2):
	var center = size / 2.0
	var offset = position - center

	var radius = (size.x - knob.size.x) / 2.0

	if offset.length() > radius:
		offset = offset.normalized() * radius

	knob.position = center + offset - knob.size / 2.0

	input_vector = offset / radius


func reset_knob():
	knob.position = (size - knob.size) / 2.0

func get_input_vector() -> Vector2:
	return input_vector

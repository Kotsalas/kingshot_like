extends Control

@onready var base: TextureRect = $Base
@onready var knob: TextureRect = $Knob

@export var joystick_radius := 70.0
@export var deadzone := 0.12

var input_vector := Vector2.ZERO

var active := false
var active_touch := -1

var joystick_center := Vector2.ZERO

var mouse_active := false

var visual_tween: Tween

func _ready():
	base.hide()
	knob.hide()

func get_input_vector() -> Vector2:
	return input_vector

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			if not active:
				start_joystick(event.position)
				
				active = true
				active_touch = event.index
				
				get_viewport().set_input_as_handled()
		
		else:
			if active and event.index == active_touch:
				stop_joystick()
				
				get_viewport().set_input_as_handled()
	
	elif event is InputEventScreenDrag:
		if active and event.index == active_touch:
			update_joystick(event.position)
			
			get_viewport().set_input_as_handled()
	
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if not active:
					start_joystick(event.position)
					
					active = true
					mouse_active = true
					
					get_viewport().set_input_as_handled()
			
			elif mouse_active:
				stop_joystick()
				mouse_active = false
				
				get_viewport().set_input_as_handled()
	
	elif event is InputEventMouseMotion:
		if mouse_active:
			update_joystick(event.position)
			
			get_viewport().set_input_as_handled()

func start_joystick(touch_position: Vector2):
	var half_size = base.size / 2.0
	
	joystick_center.x = clamp(
		touch_position.x,
		half_size.x,
		size.x - half_size.x
	)
	
	joystick_center.y = clamp(
		touch_position.y,
		half_size.y,
		size.y - half_size.y
	)
	
	base.position = joystick_center - base.size / 2.0
	knob.position = joystick_center - knob.size / 2.0
	
	if visual_tween and visual_tween.is_valid():
		visual_tween.kill()
	
	base.show()
	knob.show()
	
	base.modulate.a = 0.0
	knob.modulate.a = 0.0
	
	base.scale = Vector2(0.9, 0.9)
	knob.scale = Vector2(0.9, 0.9)
	
	visual_tween = create_tween()
	visual_tween.set_parallel(true)
	visual_tween.set_trans(Tween.TRANS_BACK)
	visual_tween.set_ease(Tween.EASE_OUT)
	
	visual_tween.tween_property(base, "modulate:a", 1.0, 0.08)
	visual_tween.tween_property(knob, "modulate:a", 1.0, 0.08)
	
	visual_tween.tween_property(base, "scale", Vector2.ONE, 0.10)
	visual_tween.tween_property(knob, "scale", Vector2.ONE, 0.10)
	
	update_joystick(touch_position)

func update_joystick(touch_position: Vector2):
	var offset = touch_position - joystick_center
	
	if offset.length() > joystick_radius:
		offset = offset.normalized() * joystick_radius
	
	knob.position = joystick_center + offset - knob.size / 2.0
	
	input_vector = offset / joystick_radius
	
	if input_vector.length() < deadzone:
		input_vector = Vector2.ZERO


func stop_joystick():
	active = false
	active_touch = -1
	input_vector = Vector2.ZERO
	
	if visual_tween and visual_tween.is_valid():
		visual_tween.kill()
	
	visual_tween = create_tween()
	visual_tween.set_parallel(true)
	
	visual_tween.tween_property(base, "modulate:a", 0.0, 0.08)
	visual_tween.tween_property(knob, "modulate:a", 0.0, 0.08)
	
	await visual_tween.finished
	
	base.hide()
	knob.hide()

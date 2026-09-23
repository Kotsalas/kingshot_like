extends Node

@export var visual: Node3D

var current_tween: Tween

func _ready() -> void:
	visual.scale = Vector3.ZERO
	
	current_tween = create_tween()
	current_tween.set_trans(Tween.TRANS_BACK)
	current_tween.set_ease(Tween.EASE_OUT)
	current_tween.tween_property(
		visual,
		"scale",
		Vector3.ONE,
		0.25
	)

func focus_platform():
	_stop_current_tween()
	
	current_tween = create_tween()
	current_tween.set_trans(Tween.TRANS_BACK)
	current_tween.set_ease(Tween.EASE_OUT)
	current_tween.tween_property(
		visual,
		"scale",
		Vector3.ONE * 1.12,
		0.5
	)

func unfocus_platform():
	_stop_current_tween()
	
	current_tween = create_tween()
	current_tween.set_trans(Tween.TRANS_QUAD)
	current_tween.set_ease(Tween.EASE_OUT)
	current_tween.tween_property(
		visual,
		"scale",
		Vector3.ONE,
		0.25
	)

func complete_platform() -> Signal:
	_stop_current_tween()
	
	current_tween = create_tween()
	current_tween.set_trans(Tween.TRANS_QUAD)
	current_tween.set_ease(Tween.EASE_IN)
	
	current_tween.tween_property(
		visual,
		"scale",
		Vector3.ZERO,
		0.25
	)
	
	return current_tween.finished

func _stop_current_tween():
	if current_tween and current_tween.is_valid():
		current_tween.kill()

extends Button

var feedback_tween: Tween

func _ready():
	await get_tree().process_frame
	pivot_offset = size / 2.0

func _on_button_down():
	animate_scale(Vector2.ONE * 0.94, 0.07)

func _on_button_up():
	animate_scale(Vector2.ONE, 0.12, true)

func animate_scale(target_scale: Vector2, duration: float, bounce := false):
	if feedback_tween and feedback_tween.is_valid():
		feedback_tween.kill()
	
	feedback_tween = create_tween()
	
	if bounce:
		feedback_tween.set_trans(Tween.TRANS_BACK)
		feedback_tween.set_ease(Tween.EASE_OUT)
	else:
		feedback_tween.set_trans(Tween.TRANS_QUAD)
		feedback_tween.set_ease(Tween.EASE_OUT)
	
	feedback_tween.tween_property(
		self,
		"scale",
		target_scale,
		duration
	)

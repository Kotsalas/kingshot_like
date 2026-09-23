extends CanvasLayer

@export var fade_duration := 0.25

@onready var fade: ColorRect = $Fade

var transitioning := false

func transition_to(scene_path: String):
	if transitioning:
		return
	
	transitioning = true
	
	await fade_out()
	
	# Important if we're leaving a paused win/loss screen.
	get_tree().paused = false
	
	get_tree().change_scene_to_file(scene_path)
	
	# Give the new scene one frame to initialize.
	await get_tree().process_frame
	
	await fade_in()
	
	transitioning = false


func reload_current_scene():
	if transitioning:
		return
		
	var scene_path = get_tree().current_scene.scene_file_path
	transition_to(scene_path)

func fade_out():
	fade.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		fade,
		"modulate:a",
		1.0,
		fade_duration
	)
	
	await tween.finished


func fade_in():
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(
		fade,
		"modulate:a",
		0.0,
		fade_duration
	)
	
	await tween.finished
	
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE

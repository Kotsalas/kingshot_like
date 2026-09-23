extends Control

@onready var dim_background = $DimBackground
@onready var result_panel = $ResultPanel
@onready var result_title = $ResultPanel/VBoxContainer/ResultTitle
@onready var next_button = $ResultPanel/VBoxContainer/NextButton
@onready var restart_button = $ResultPanel/VBoxContainer/RestartButton
@onready var levels_button = $ResultPanel/VBoxContainer/LevelsButton

func _ready():
	visible = false

func show_result(won: bool):
	visible = true
	
	if won:
		result_title.text = "LEVEL COMPLETE"
		next_button.visible = true
	else:
		result_title.text = "LEVEL FAILED"
		next_button.visible = false
	
	# Wait until UI sizes are calculated.
	await get_tree().process_frame
	
	result_panel.pivot_offset = result_panel.size / 2.0
	
	# Initial animation state.
	dim_background.modulate.a = 0.0
	
	result_panel.scale = Vector2(0.75, 0.75)
	result_panel.modulate.a = 0.0
	
	result_title.modulate.a = 0.0
	
	next_button.modulate.a = 0.0
	restart_button.modulate.a = 0.0
	levels_button.modulate.a = 0.0
	next_button.scale = Vector2(0.85, 0.85)
	restart_button.scale = Vector2(0.85, 0.85)
	levels_button.scale = Vector2(0.85, 0.85)
	
	# Background fade.
	var dim_tween = create_tween()
	dim_tween.tween_property(
		dim_background,
		"modulate:a",
		1.0,
		0.25
	)
	
	# Panel pop.
	var panel_tween = create_tween()
	panel_tween.set_parallel(true)
	panel_tween.set_trans(Tween.TRANS_BACK)
	panel_tween.set_ease(Tween.EASE_OUT)
	panel_tween.tween_property(
		result_panel,
		"scale",
		Vector2.ONE,
		0.3
	)
	panel_tween.tween_property(
		result_panel,
		"modulate:a",
		1.0,
		0.2
	)
	
	var content_tween = create_tween()
	content_tween.tween_interval(0.12)
	content_tween.tween_property(
		result_title,
		"modulate:a",
		1.0,
		0.15
	)
	content_tween.tween_interval(0.05)
	
	var buttons = []
	
	if won:
		buttons.append(next_button)
	
	buttons.append(restart_button)
	buttons.append(levels_button)
	
	for button in buttons:
		content_tween.set_parallel(true)
		content_tween.tween_property(
			button,
			"modulate:a",
			1.0,
			0.12
		)
		content_tween.tween_property(
			button,
			"scale",
			Vector2.ONE,
			0.15
		).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		content_tween.set_parallel(false)
		content_tween.tween_interval(0.05)

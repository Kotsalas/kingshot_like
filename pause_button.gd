extends Button

@export var result_overlay: Control

func _on_pause_button_pressed() -> void:
	result_overlay.process_mode = Node.PROCESS_MODE_ALWAYS
	result_overlay.call("show_pause_menu")
	get_tree().paused = true

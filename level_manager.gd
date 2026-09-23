extends Node

@export var level_number := 1

var spawning_finished := false
var level_complete := false
var level_failed = false

func _process(_delta):
	if not spawning_finished or level_complete:
		return

	if get_tree().get_nodes_in_group("enemies").is_empty():
		complete_level()

func _on_enemy_spawner_all_waves_spawned() -> void:
	stop_spawning()

func _on_enemy_spawner_2_all_waves_spawned() -> void:
	stop_spawning()

func _on_base_destroyed():
	if level_complete:
		return
	
	level_failed = true
	
	await get_tree().create_timer(0.4).timeout
	
	get_tree().paused = true
	$"../UI/ResultOverlay".show_result(false)

func complete_level():
	if level_complete:
		return
	
	level_complete = true
	
	GameManager.complete_level(level_number)
	
	await get_tree().create_timer(0.5).timeout
	
	get_tree().paused = true
	$"../UI/ResultOverlay".show_result(true)

func _on_restart_button_pressed() -> void:
	SceneTransition.reload_current_scene()

func _on_next_button_pressed() -> void:
	get_tree().paused = false
	GameManager.load_level(level_number + 1)

func _on_levels_button_pressed() -> void:
	get_tree().paused = false
	SceneTransition.transition_to("res://level_select.tscn")

func stop_spawning():
	spawning_finished = true

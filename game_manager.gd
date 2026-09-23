extends Node

const SAVE_PATH := "user://save.cfg"

var current_level := 1
var highest_unlocked_level := 1

func _ready():
	load_progress()

func load_progress():
	var config = ConfigFile.new()
	
	var error = config.load(SAVE_PATH)
	
	if error != OK:
		print("No save file found. Starting new game.")
		return
	
	highest_unlocked_level = config.get_value(
		"progress",
		"highest_unlocked_level",
		1
	)
	
	print("Loaded progress. Highest unlocked level:", highest_unlocked_level)

func save_progress():
	var config = ConfigFile.new()
	
	config.set_value(
		"progress",
		"highest_unlocked_level",
		highest_unlocked_level
	)
	
	config.save(SAVE_PATH)

func reset_progress():
	highest_unlocked_level = 1
	save_progress()
	print("Progress reset.")

func complete_level(level_number: int):
	if level_number >= highest_unlocked_level:
		highest_unlocked_level = level_number + 1
		save_progress()

func load_level(level_number: int):
	current_level = level_number
	
	SceneTransition.transition_to(
		"res://levels/level_" + str(level_number) + ".tscn"
	)

extends Control

var LEVELS_PER_CHAPTER := 5

var current_chapter := 1
var total_chapters := 3

var chapter_names = [
	"Grasslands",
	"Desert",
	"Snow"
]

var swipe_start_position := Vector2.ZERO
var swipe_threshold := 80.0

func _ready():
	update_chapter()

func update_chapter():
	$ChapterTitle.text = chapter_names[current_chapter - 1]
	
	$LeftArrow.visible = current_chapter > 1
	$RightArrow.visible = current_chapter < total_chapters
	
	update_level_buttons()

func update_level_buttons():
	var first_level = ((current_chapter - 1) * LEVELS_PER_CHAPTER) + 1

	var buttons = [
		$Levels/Level1Button,
		$Levels/Level2Button,
		$Levels/Level3Button,
		$Levels/Level4Button,
		$Levels/Level5Button
	]

	for i in range(buttons.size()):
		var level_number = first_level + i

		buttons[i].text = "Level " + str(level_number)
		buttons[i].disabled = (
			level_number > GameManager.highest_unlocked_level
		)

func _on_left_arrow_button_up() -> void:
	previous_chapter()

func _on_right_arrow_button_up() -> void:
	next_chapter()

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			swipe_start_position = event.position
		else:
			handle_swipe(event.position)
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				swipe_start_position = event.position
			else:
				handle_swipe(event.position)

func handle_swipe(end_position: Vector2):
	var swipe_distance = end_position.x - swipe_start_position.x
	
	if abs(swipe_distance) < swipe_threshold:
		return
	
	if swipe_distance < 0:
		next_chapter()
	else:
		previous_chapter()

func next_chapter():
	if current_chapter >= total_chapters:
		return
	
	current_chapter += 1
	update_chapter()

func previous_chapter():
	if current_chapter <= 1:
		return
	
	current_chapter -= 1
	update_chapter()

func _on_level_1_button_button_up() -> void:
	GameManager.load_level(1)

func _on_level_2_button_button_up() -> void:
	GameManager.load_level(2)

func _on_level_3_button_button_up() -> void:
	GameManager.load_level(3)

func _on_level_4_button_button_up() -> void:
	GameManager.load_level(4)

func _on_level_5_button_button_up() -> void:
	GameManager.load_level(5)

extends Control

@export var chapter_sky_textures: Array[Texture2D]
@export var chapter_far_textures: Array[Texture2D]
@export var chapter_near_textures: Array[Texture2D]

@onready var sky: TextureRect = $BackgroundRoot/Sky
@onready var far_terrain: TextureRect = $BackgroundRoot/FarTerrain
@onready var near_terrain: TextureRect = $BackgroundRoot/NearTerrain
@onready var left_arrow: Button = $SafeMargin/Center/ChapterContent/ChapterHeader/ChapterRow/LeftArrow
@onready var right_arrow: Button = $SafeMargin/Center/ChapterContent/ChapterHeader/ChapterRow/RightArrow
@onready var level_button_1: Button = $SafeMargin/Center/ChapterContent/ChapterHeader/ChapterRow/MainPanel/PanelMargin/LevelRows/Row1/Level1Button
@onready var level_button_2: Button = $SafeMargin/Center/ChapterContent/ChapterHeader/ChapterRow/MainPanel/PanelMargin/LevelRows/Row1/Level2Button
@onready var level_button_3: Button = $SafeMargin/Center/ChapterContent/ChapterHeader/ChapterRow/MainPanel/PanelMargin/LevelRows/Row1/Level3Button
@onready var level_button_4: Button = $SafeMargin/Center/ChapterContent/ChapterHeader/ChapterRow/MainPanel/PanelMargin/LevelRows/Row2/Level4Button
@onready var level_button_5: Button = $SafeMargin/Center/ChapterContent/ChapterHeader/ChapterRow/MainPanel/PanelMargin/LevelRows/Row2/Level5Button
@onready var chapter_content: VBoxContainer = $SafeMargin/Center/ChapterContent

const AVAILABLE_COLOR := Color("#5FAE4E")
const HIGHLIGHT_COLOR := Color("#E8B84A")
const LOCKED_COLOR := Color("#8C8578")
const BORDER_COLOR := Color("#2B2118")

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
var chapter_animating = false

var far_idle_tween: Tween
var near_idle_tween: Tween
var far_base_position: Vector2
var near_base_position: Vector2

func _ready():
	far_base_position = far_terrain.position
	near_base_position = near_terrain.position
	
	update_background()
	start_background_idle()
	update_chapter()

func update_chapter():
	$SafeMargin/Center/ChapterContent/ChapterHeader/ChapterNumber.text = "CHAPTER " + str(current_chapter)
	$SafeMargin/Center/ChapterContent/ChapterHeader/ChapterTitle.text = chapter_names[current_chapter - 1]
	
	left_arrow.disabled = current_chapter == 1
	right_arrow.disabled = current_chapter == total_chapters
	
	update_level_buttons()

func update_level_buttons():
	var first_level = ((current_chapter - 1) * LEVELS_PER_CHAPTER) + 1
	
	var buttons = [
		level_button_1,
		level_button_2,
		level_button_3,
		level_button_4,
		level_button_5
	]
	
	for i in range(buttons.size()):
		var button = buttons[i]
		var level_number = first_level + i
		
		button.text = str(level_number)
		
		if level_number > GameManager.highest_unlocked_level:
			# Locked
			button.disabled = true
			button.add_theme_stylebox_override(
				"disabled",
				make_button_style(LOCKED_COLOR)
			)
		
		elif level_number == GameManager.highest_unlocked_level:
			# Newest available
			button.disabled = false
			button.add_theme_stylebox_override(
				"normal",
				make_button_style(HIGHLIGHT_COLOR)
			)
			button.add_theme_stylebox_override(
				"hover",
				make_button_style(HIGHLIGHT_COLOR.lightened(0.1))
			)
			button.add_theme_stylebox_override(
				"pressed",
				make_button_style(HIGHLIGHT_COLOR.darkened(0.15))
			)
		
		else:
			# Previously unlocked/completed
			button.disabled = false
			button.add_theme_stylebox_override(
				"normal",
				make_button_style(AVAILABLE_COLOR)
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
	
	animate_chapter_change(1)

func previous_chapter():
	if current_chapter <= 1:
		return
	
	animate_chapter_change(-1)

func _on_level_1_button_button_up() -> void:
	GameManager.load_chapter_level(0, current_chapter, LEVELS_PER_CHAPTER)

func _on_level_2_button_button_up() -> void:
	GameManager.load_chapter_level(1, current_chapter, LEVELS_PER_CHAPTER)

func _on_level_3_button_button_up() -> void:
	GameManager.load_chapter_level(2, current_chapter, LEVELS_PER_CHAPTER)

func _on_level_4_button_button_up() -> void:
	GameManager.load_chapter_level(3, current_chapter, LEVELS_PER_CHAPTER)

func _on_level_5_button_button_up() -> void:
	GameManager.load_chapter_level(4, current_chapter, LEVELS_PER_CHAPTER)

func animate_chapter_change(direction: int):
	if chapter_animating:
		return
	
	chapter_animating = true
	stop_background_idle()
	var content_start := chapter_content.position
	
	var out_tween = create_tween()
	out_tween.set_parallel(true)
	out_tween.set_trans(Tween.TRANS_QUAD)
	out_tween.set_ease(Tween.EASE_IN)
	
	out_tween.tween_property(
		chapter_content,
		"position:x",
		content_start.x - (80.0 * direction),
		0.15
	)
	
	out_tween.tween_property(
		chapter_content,
		"modulate:a",
		0.0,
		0.15
	)
	
	out_tween.tween_property(
		sky,
		"modulate:a",
		0.0,
		0.15
	)
	
	out_tween.tween_property(
		far_terrain,
		"position:x",
		far_base_position.x - (40.0 * direction),
		0.15
	)
	
	out_tween.tween_property(
		far_terrain,
		"modulate:a",
		0.0,
		0.15
	)
	
	out_tween.tween_property(
		near_terrain,
		"position:x",
		near_base_position.x - (80.0 * direction),
		0.15
	)
	
	out_tween.tween_property(
		near_terrain,
		"modulate:a",
		0.0,
		0.15
	)
	
	await out_tween.finished
	
	current_chapter += direction
	
	update_chapter()
	update_background()
	
	chapter_content.position.x = content_start.x + (80.0 * direction)
	chapter_content.modulate.a = 0.0
	
	sky.modulate.a = 0.0
	
	far_terrain.position.x = far_base_position.x + (40.0 * direction)
	far_terrain.modulate.a = 0.0
	
	near_terrain.position.x = near_base_position.x + (80.0 * direction)
	near_terrain.modulate.a = 0.0
	
	var in_tween = create_tween()
	in_tween.set_parallel(true)
	in_tween.set_trans(Tween.TRANS_QUAD)
	in_tween.set_ease(Tween.EASE_OUT)
	
	in_tween.tween_property(
		chapter_content,
		"position:x",
		content_start.x,
		0.18
	)
	
	in_tween.tween_property(
		chapter_content,
		"modulate:a",
		1.0,
		0.18
	)
	
	in_tween.tween_property(
		sky,
		"modulate:a",
		1.0,
		0.18
	)
	
	in_tween.tween_property(
		far_terrain,
		"position:x",
		far_base_position.x,
		0.18
	)
	
	in_tween.tween_property(
		far_terrain,
		"modulate:a",
		1.0,
		0.18
	)
	
	in_tween.tween_property(
		near_terrain,
		"position:x",
		near_base_position.x,
		0.18
	)
	
	in_tween.tween_property(
		near_terrain,
		"modulate:a",
		1.0,
		0.18
	)
	
	await in_tween.finished
	
	start_background_idle()
	
	chapter_animating = false

func make_button_style(color: Color) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	
	style.bg_color = color
	style.border_color = BORDER_COLOR
	
	style.border_width_left = 6
	style.border_width_top = 6
	style.border_width_right = 6
	style.border_width_bottom = 6
	
	style.corner_radius_top_left = 22
	style.corner_radius_top_right = 22
	style.corner_radius_bottom_left = 22
	style.corner_radius_bottom_right = 22
	
	return style

func start_background_idle():
	far_idle_tween = create_tween()
	far_idle_tween.set_loops()
	far_idle_tween.set_trans(Tween.TRANS_SINE)
	far_idle_tween.set_ease(Tween.EASE_IN_OUT)
	
	far_idle_tween.tween_property(
		far_terrain,
		"position:x",
		far_base_position.x + 6.0,
		4.0
	)
	
	far_idle_tween.tween_property(
		far_terrain,
		"position:x",
		far_base_position.x - 6.0,
		4.0
	)
	
	near_idle_tween = create_tween()
	near_idle_tween.set_loops()
	near_idle_tween.set_trans(Tween.TRANS_SINE)
	near_idle_tween.set_ease(Tween.EASE_IN_OUT)
	
	near_idle_tween.tween_property(
		near_terrain,
		"position:x",
		near_base_position.x + 12.0,
		3.5
	)
	
	near_idle_tween.tween_property(
		near_terrain,
		"position:x",
		near_base_position.x - 12.0,
		3.5
	)

func stop_background_idle():
	if far_idle_tween and far_idle_tween.is_valid():
		far_idle_tween.kill()
		
	if near_idle_tween and near_idle_tween.is_valid():
		near_idle_tween.kill()
		
	far_terrain.position = far_base_position
	near_terrain.position = near_base_position

func update_background():
	var index = current_chapter - 1
	
	sky.texture = chapter_sky_textures[index]
	far_terrain.texture = chapter_far_textures[index]
	near_terrain.texture = chapter_near_textures[index]

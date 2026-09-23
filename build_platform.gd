extends Area3D

@export var build_cost: int = 10
@export var tower_location: Marker3D
@export var tower_scene: PackedScene
@export var coin_scene: PackedScene

@onready var progress_label: Label = $SubViewport/Label
@onready var platform_helper = $PlatformHandlingHelper

var coins_spent := 0
var coins_in_flight := 0
var player_is_building := false
var build_completed := false

func _ready() -> void:
	update_progress_text()

func _on_body_entered(body):
	if body.name == "Player":
		platform_helper.focus_platform()
		player_is_building = true
		$BuildTimer.start()

func _on_body_exited(body):
	if body.name == "Player":
		player_is_building = false
		$BuildTimer.stop()
		
		if not build_completed:
			platform_helper.unfocus_platform()

func _on_build_timer_timeout():
	if not player_is_building:
		return
	
	if coins_spent + coins_in_flight >= build_cost:
		$BuildTimer.stop()
		return
	
	var player = get_tree().current_scene.get_node("Player")
	
	if player.coins > 0 :
		player.coins -= 1
		player.update_coin_ui()
		
		coins_in_flight += 1
		
		var coin = coin_scene.instantiate()
		get_tree().current_scene.add_child(coin)
		
		coin.global_position = player.global_position
		coin.target = self
		coin.amount = 1
		coin.on_arrival = Callable(self, "add_coins")
		
		coin.setup_start_position()
	else:
		$BuildTimer.stop()

func build_tower():
	var tower = tower_scene.instantiate()
	get_tree().current_scene.add_child(tower)
	tower.global_transform = tower_location.global_transform
	tower.play_spawn_animation()
	
	queue_free()

func update_progress_text():
	progress_label.text = str(build_cost - coins_spent)

func add_coins(amount):
	coins_in_flight -= amount
	coins_spent += amount
	update_progress_text()

	if coins_spent >= build_cost:
		build_completed = true
		$BuildTimer.stop()
		await platform_helper.complete_platform()
		build_tower()

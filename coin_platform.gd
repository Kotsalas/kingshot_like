extends Area3D

@onready var progress_label: Label = $SubViewport/Label
@onready var tower = get_parent()
@onready var platform_helper = $PlatformHandlingHelper

@export var coin_scene: PackedScene

var player_is_collecting := false

func _ready() -> void:
	$Visual/Sprite3D.texture = $SubViewport.get_texture()
	update_progress_text()

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		platform_helper.focus_platform()
		player_is_collecting = true
		$CoinCollectTimer.start()

func _on_body_exited(body):
	if body.name == "Player":
		platform_helper.unfocus_platform()
		player_is_collecting = false
		$CoinCollectTimer.stop()

func _on_coin_collect_timer_timeout() -> void:
	if not player_is_collecting or tower.coins <= 0:
		return
	
	var player = get_tree().current_scene.get_node("Player")
	
	if tower.coins > 0:
		tower.coins -= 1
		update_progress_text()

		var coin = coin_scene.instantiate()
		get_tree().current_scene.add_child(coin)

		coin.global_position = global_position
		coin.target = player
		coin.amount = 1
		coin.on_arrival = Callable(player, "add_coins")
		
		coin.setup_start_position()

func update_progress_text():
	progress_label.text = str(tower.coins)

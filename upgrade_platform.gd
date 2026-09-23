extends Area3D

@onready var progress_label: Label = $SubViewport/Label
@onready var tower = get_parent()
@onready var platform_helper = $PlatformHandlingHelper

@export var coin_scene: PackedScene

var coins_spent := 0
var coins_in_flight := 0
var player_is_upgrading := false

func _ready() -> void:
	$Visual/Sprite3D.texture = $SubViewport.get_texture()
	update_progress_text()

func _on_body_entered(body):
	if body.name == "Player":
		platform_helper.focus_platform()
		player_is_upgrading = true
		$UpgradeTimer.start()

func _on_body_exited(body):
	if body.name == "Player":
		platform_helper.unfocus_platform()
		player_is_upgrading = false
		$UpgradeTimer.stop()

func _on_upgrade_timer_timeout():	
	if not player_is_upgrading:
		return
	
	if coins_spent + coins_in_flight >= tower.upgrade_cost:
		$UpgradeTimer.stop()
		return

	var player = get_tree().current_scene.get_node("Player")

	if player.coins > 0:
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
		
		if coins_spent >= tower.upgrade_cost:
			$UpgradeTimer.stop()
			
			tower.upgrade()
	else:
		$UpgradeTimer.stop()

func add_coins(amount):
	coins_in_flight -= 1
	coins_spent += amount
	update_progress_text()
	
	if coins_spent >= tower.upgrade_cost:
		$UpgradeTimer.stop()
		await platform_helper.complete_platform()
		tower.upgrade()

func update_progress_text():
	progress_label.text = str(tower.upgrade_cost - coins_spent)

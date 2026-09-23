extends CharacterBody3D

@export var bullet_scene: PackedScene
@export var push_strength := 1.0
@export var push_distance := 0.5

const SPEED = 10.0
const GRAVITY = 9.8

var targets: Array[Node3D] = []
var coins := 100

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
		
	targets = targets.filter(is_instance_valid)

	if not targets.is_empty():
		$Muzzle.look_at(targets[0].global_position, Vector3.UP)
	
	var input = $"../UI/Joystick".get_input_vector()
	var direction = Vector3(input.x, 0, input.y).normalized()
	
	if direction.length() > 0.01:
		$player.look_at($player.global_position - direction, Vector3.UP)
	
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	move_and_slide()
	
	if not targets.is_empty():
		$Muzzle.look_at(targets[0].global_position, Vector3.UP)

func _on_shoot_timer_timeout() -> void:
	shoot()

func shoot():
	targets = targets.filter(is_instance_valid)
	
	if targets.is_empty():
		return

	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.target = targets[0]
	bullet.shooter = self
	bullet.push_strength = push_strength
	bullet.push_distance = push_distance
	$Muzzle.look_at(targets[0].global_position, Vector3.UP)
	bullet.global_transform = $Muzzle.global_transform

func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemies"):
		targets.append(body)
		
		if targets.size() == 1:
			$ShootTimer.start()

func _on_detection_area_body_exited(body: Node3D) -> void:
	if body in targets:
		targets.erase(body)
		
	if targets.is_empty():
		$ShootTimer.stop()

func add_coins(amount: int):
	coins += amount
	update_coin_ui()

func update_coin_ui():
	$"../UI/CoinLabel".text = str(coins)

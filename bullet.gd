extends Area3D

@export var speed := 25.0
@export var coin_scene: PackedScene

var target: Node3D
var shooter: Node
var damage := 1
var push_strength := 0.0
var push_distance := 0.0

func _physics_process(delta):
	if is_instance_valid(target):
		look_at(target.global_position, Vector3.UP)
	
	global_position += -global_transform.basis.z * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		var enemy_position = body.global_position
		body.apply_knockback(push_strength, push_distance)
		var reward = body.take_damage(damage)
		
		if reward > 0 and (shooter.name == "Player" or shooter.is_in_group("towers")):
			for i in range(reward):
				var coin = coin_scene.instantiate()
				get_tree().current_scene.add_child(coin)
				
				var offset = Vector3(
					randf_range(-0.5, 0.5),
					randf_range(0.0, 0.5),
					randf_range(-0.5, 0.5)
				)
				
				coin.global_position = enemy_position + offset
				coin.target = shooter
				coin.amount = 1
				coin.on_arrival = Callable(shooter, "add_coins")
				
				coin.randomize_travel()
				coin.setup_start_position()
	
	queue_free()

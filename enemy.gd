extends CharacterBody3D

@export var max_health := 1
@export var speed_multiplier := 1.0
@export var damage = 10
@export var weight := 1.0
@export var coin_reward := 1

@onready var health_bar: ProgressBar = $HealthBarViewport/HealthBar
@onready var health_bar_helper = $HealthBarViewport/HealthBarHelper

var health: int
var dead := false
var flash_material: StandardMaterial3D

const SPEED = 5.0

func _ready() -> void:
	health = max_health
	
	health_bar_helper.setup(
		health,
		max_health
	)
	
	flash_material = StandardMaterial3D.new()
	flash_material.albedo_color = Color.DARK_RED
	flash_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
  
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := (transform.basis * Vector3()).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func apply_knockback(push_strength: float, push_distance: float):
	if push_strength < weight:
		return
		
	var path_follow = get_parent()
	
	if path_follow is PathFollow3D:
		path_follow.apply_knockback(push_distance)

func take_damage(amount):
	if dead:
		return 0
	
	health -= amount
	health_bar_helper.update_health(health, max_health)
	play_hit_flash()
	
	if health <= 0:
		dead = true
		var reward = coin_reward
		die()
		return reward
	
	return 0

func die():
	remove_from_group("enemies")
	
	collision_layer = 0
	
	var path_follow = get_parent()
	path_follow.set_process(false)
	
	await fade_out()
	path_follow.queue_free()

func fade_out():
	var meshes = find_children("*", "MeshInstance3D", true, false)
	var tween = create_tween()
	tween.set_parallel(true)
	
	for mesh: MeshInstance3D in meshes:
		for i in range(mesh.get_surface_override_material_count()):
			var material = mesh.get_active_material(i)
			
			if material is StandardMaterial3D:
				material = material.duplicate()
				material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
				
				mesh.set_surface_override_material(i, material)
				
				tween.tween_property(
					material,
					"albedo_color:a",
					0.0,
					0.35
				)
	
	await tween.finished

func play_hit_flash():
	var meshes = find_children("*", "MeshInstance3D", true, false)
	
	for mesh in meshes:
		mesh.material_override = flash_material
	
	await get_tree().create_timer(0.06).timeout
	
	if not is_instance_valid(self):
		return
	
	for mesh in meshes:
		if is_instance_valid(mesh):
			mesh.material_override = null

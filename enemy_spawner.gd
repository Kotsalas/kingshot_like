extends Node

@export var normal_enemy_scene: PackedScene
@export var tank_enemy_scene: PackedScene
@export var enemy_path: Path3D

signal all_waves_spawned

@export var waves: Array[WaveData]
@export var max_waves := 3

var current_wave_enemies: Array[PackedScene] = []
var current_enemy_index := 0
var current_wave := 0
var enemies_spawned := 0
var normal_spawned := 0
var tank_spawned := 0

func _ready():
	if waves.is_empty():
		return
	
	prepare_wave()
	spawn_enemy()

func _on_spawn_timer_timeout():
	spawn_enemy()

func spawn_enemy():
	if current_enemy_index >= current_wave_enemies.size():
		$SpawnTimer.stop()
		$WaveTimer.start()
		return
	
	var enemy_scene_to_spawn = current_wave_enemies[current_enemy_index]
	current_enemy_index += 1
	
	var path_follow = PathFollow3D.new()
	path_follow.set_script(preload("res://enemy_path_follow.gd"))
	enemy_path.add_child(path_follow)
	
	var enemy = enemy_scene_to_spawn.instantiate()
	path_follow.add_child(enemy)

func _on_wave_timer_timeout() -> void:
	current_wave += 1
	
	if current_wave >= waves.size():
		all_waves_spawned.emit()
		return
	
	prepare_wave()
	$SpawnTimer.start()

func prepare_wave():
	current_wave_enemies.clear()
	current_enemy_index = 0
	
	var wave = waves[current_wave]
	
	for i in range(wave.normal_enemies):
		current_wave_enemies.append(normal_enemy_scene)
	
	for i in range(wave.tank_enemies):
		current_wave_enemies.append(tank_enemy_scene)
	
	current_wave_enemies.shuffle()

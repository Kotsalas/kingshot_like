extends Resource
class_name WaveData

@export var normal_enemies := 10
@export var tank_enemies := 0

func total_enemies() -> int:
	return normal_enemies + tank_enemies

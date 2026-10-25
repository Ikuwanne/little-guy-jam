extends Node

signal penalty_at_zero
signal task_completed(index: int)

var shoe_task: Array[int] = [2, 5, 8]  
var score: int = 0

@export var start_speed := 100.0
@export var end_speed := 150.0
@export var ramp_duration := 240.0

var game_time := 0.0

func _process(delta: float) -> void:
	game_time += delta

func get_speed() -> float:
	return lerpf(start_speed, end_speed, clampf(game_time / ramp_duration, 0.0, 1.0))

func reset_run() -> void:
	game_time = 0.0
	score = 0
	
func random_task() -> int:
	return randi_range(2, 27)  

func validate_shoe(id: int) -> bool:
	var index := shoe_task.find(id)
	if index == -1:
		return false
	shoe_task[index] = random_task()
	task_completed.emit(index)
	return true

func regenerate_all() -> void:
	shoe_task = [2, 5, 8]  

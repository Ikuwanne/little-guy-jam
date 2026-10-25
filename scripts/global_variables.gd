extends Node

var shoe_task: Array[int] = [2, 5, 8]  
var score: int = 0

func random_task() -> int:
	return randi_range(2, 27)  

signal task_completed(index: int)

func validate_shoe(id: int) -> bool:
	var index := shoe_task.find(id)
	if index == -1:
		return false
	shoe_task[index] = random_task()
	task_completed.emit(index)
	return true

func regenerate_all() -> void:
	for i in shoe_task.size():
		shoe_task[i] = random_task()

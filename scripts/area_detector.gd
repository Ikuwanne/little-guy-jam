extends Area2D

var shoes_in_area: Array[Area2D] = []
var is_player: bool

func is_shoes_in_area() -> bool:
	return not shoes_in_area.is_empty()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("shoes"):
		shoes_in_area.append(area)

func _on_area_exited(area: Area2D) -> void:
	shoes_in_area.erase(area)



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player = true
	
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player = false
		
func can_interact() -> bool:
	return is_player and is_shoes_in_area()

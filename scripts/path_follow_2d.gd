extends PathFollow2D
signal penalty_at_zero

func _process(delta: float) -> void:
	progress += delta * GlobalVariables.get_speed()
	if progress_ratio >= 1.0 and get_child_count() > 0:
		var shoes = get_child(0)
		var id: int = shoes.get_shoe_id()
		
		if GlobalVariables.validate_shoe(id):
			GlobalVariables.score += 10
		else:
			if GlobalVariables.score <= 0:
				GlobalVariables.penalty_at_zero.emit()
			else:
				GlobalVariables.score = maxi(0, GlobalVariables.score - 10)
		
		queue_free()

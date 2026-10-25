extends PathFollow2D
signal penalty_at_zero
@export var speed = 200

func _process(delta: float) -> void:
	progress += delta * speed
	if progress_ratio >= 1.0 and get_child_count() > 0:
		var shoes = get_child(0)
		var id: int = shoes.get_shoe_id()
		
		if GlobalVariables.validate_shoe(id):
			print("Bonne chaussure ! ID ", id)
			GlobalVariables.score += 10
		else:
			print("Mauvaise chaussure... ID ", id)
			if GlobalVariables.score <= 0:
				GlobalVariables.penalty_at_zero.emit()
			else:
				GlobalVariables.score = maxi(0, GlobalVariables.score - 10)

		
		queue_free()  # supprime le follower et la chaussure avec

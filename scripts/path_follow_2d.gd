
extends PathFollow2D
signal penalty_at_zero

@export var speed = 200

func _process(delta: float) -> void:
	progress += delta * GlobalVariables.get_speed()
	
	if progress_ratio >= 1.0 and get_child_count() > 0:
		var shoe = get_child(0)
		
		var shoe_type_file = shoe.get_child(0).texture.resource_path.get_file()
		var package_type_file = shoe.get_child(1).texture.resource_path.get_file()
		var shoe_type = 0
		var shoe_color = 0
		var package = 0
		
		if "Boot" in shoe_type_file:
			shoe_type = 1
		elif "Shoe" in shoe_type_file:
			shoe_type = 2
		elif "Sneaker" in shoe_type_file:
			shoe_type = 3
		
		if "Brown" in shoe_type_file:
			shoe_color = 0
		elif "Red" in shoe_type_file:
			shoe_color = 1
		elif "Blue" in shoe_type_file:
			shoe_color = 2
		
		if "1" in package_type_file:
			package = 1
		elif "2" in package_type_file:
			package = 2
		
		var shoe_id = (shoe_color * 9) + (shoe_type * 3) + package - 2
		
		if GlobalVariables.validate_shoe(shoe_id):
			GlobalVariables.score += 10
		else:
			if GlobalVariables.score <= 0:
				penalty_at_zero.emit()
			else:
				GlobalVariables.score = maxi(0, GlobalVariables.score - 10)
		
		var index = GlobalVariables.shoe_task.find(shoe_id)
		if index != -1:
			GlobalVariables.shoe_task[index] = randi_range(1, 27)
		
		shoe.queue_free()
		queue_free()

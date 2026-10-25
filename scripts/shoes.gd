extends Area2D

func get_shoe_id() -> int:
	var file: String = $Sprite2D.texture.resource_path.get_file()
	
	var color := 0
	if "Red" in file:
		color = 1
	elif "Blue" in file:
		color = 2
	
	var type := 1  # Shoe par défaut
	if "Boot" in file:
		type = 0
	elif "Sneaker" in file:
		type = 2
	
	var package := 0
	if $Package.texture != null:
		var pfile: String = $Package.texture.resource_path.get_file()
		if "package_1" in pfile:
			package = 1
		elif "package_2" in pfile:
			package = 2
	
	return color * 9 + type * 3 + package + 1

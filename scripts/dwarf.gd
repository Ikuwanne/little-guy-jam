extends CharacterBody2D																												

@export var speed = 200
@export var acceleration_speed = 1000
@export var deceleration_speed = 1500
@export var zoom = 1.03
@export var camera: Camera2D
@export var task_manager: NinePatchRect

var can_interact: bool
@export var area_detector_shape_1: Area2D
@export var area_detector_shape_2: Area2D

@export var area_detector_color_1: Area2D
@export var area_detector_color_2: Area2D

@export var area_detector_package_1: Area2D
@export var area_detector_package_2: Area2D

func _physics_process(delta):
	
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * speed, acceleration_speed * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration_speed * delta)
	
	if Input.is_action_pressed("run"):
		speed = 500
		acceleration_speed = 1400
		if velocity.x > speed * 0.5 or velocity.y > speed * 0.5:
			camera.zoom = camera.zoom.move_toward(Vector2.ONE / zoom, delta/2)
		else :
			camera.zoom = camera.zoom.move_toward(Vector2.ONE, delta/2)
	else :
		camera.zoom = camera.zoom.move_toward(Vector2.ONE, delta/2)
		if speed != 300:
			speed = 300
			acceleration_speed = 1200
	
	if Input.is_action_just_pressed("Interact") and area_detector_shape_1.can_interact():
		var shoes_area: Area2D = area_detector_shape_1.shoes_in_area[0]
		var sprite: Sprite2D = shoes_area.get_node("Sprite2D")
		sprite.texture = preload("res://assets/Shoes/BrownSneaker.png")
		
	if Input.is_action_just_pressed("Interact") and area_detector_shape_2.can_interact():
		var shoes_area: Area2D = area_detector_shape_2.shoes_in_area[0]
		var sprite: Sprite2D = shoes_area.get_node("Sprite2D")
		sprite.texture = preload("res://assets/Shoes/BrownShoe.png")
		
	if Input.is_action_just_pressed("Interact") and area_detector_color_1.can_interact():
		var shoes_area: Area2D = area_detector_color_1.shoes_in_area[0]
		var shoes = shoes_area.get_child(0)   # root of the shoe scene
		if "Boot" in shoes.texture.resource_path.get_file():
			shoes.texture = preload("res://assets/Shoes/RedBoot.png")
		if "Sneaker" in shoes.texture.resource_path.get_file():
			shoes.texture = preload("res://assets/Shoes/RedSneaker.png")
		if "Shoe" in shoes.texture.resource_path.get_file():
			shoes.texture = preload("res://assets/Shoes/RedShoe.png")
		
	if Input.is_action_just_pressed("Interact") and area_detector_color_2.can_interact():
		var shoes_area: Area2D = area_detector_color_2.shoes_in_area[0]
		var shoes = shoes_area.get_child(0)   # root of the shoe scene
		if "Boot" in shoes.texture.resource_path.get_file():
			shoes.texture = preload("res://assets/Shoes/BlueBoot.png")
		if "Sneaker" in shoes.texture.resource_path.get_file():
			shoes.texture = preload("res://assets/Shoes/BlueSneaker.png")
		if "Shoe" in shoes.texture.resource_path.get_file():
			shoes.texture = preload("res://assets/Shoes/BlueShoe.png")
		
	if Input.is_action_just_pressed("Interact") and area_detector_package_1.can_interact():
		var shoes_area: Area2D = area_detector_package_1.shoes_in_area[0]
		var sprite: Sprite2D = shoes_area.get_node("Package")
		sprite.texture = preload("res://assets/package_1.png")
		
	if Input.is_action_just_pressed("Interact") and area_detector_package_2.can_interact():
		var shoes_area: Area2D = area_detector_package_2.shoes_in_area[0]
		var sprite: Sprite2D = shoes_area.get_node("Package")
		sprite.texture = preload("res://assets/package_2.png")
	
	move_and_slide()

func _on_area_detect_area_entered(area: Area2D) -> void:
	if area.name == "Tasks":
		create_tween().tween_property(task_manager, "position:y", -320.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func _on_area_detect_area_exited(area: Area2D) -> void:
	if area.name == "Tasks":
		create_tween().tween_property(task_manager, "position:y", -1000.0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)

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


@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var last_direction := "down"

func _physics_process(delta):
	
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * speed, acceleration_speed * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration_speed * delta)
	
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			last_direction = "right" if direction.x > 0 else "left"
		else:
			last_direction = "down" if direction.y > 0 else "up"
		anim.play("walk_" + last_direction)
	else:
		anim.animation = "walk_" + last_direction
		anim.stop()
		anim.frame = 0
	
	
	
	if Input.is_action_just_pressed("Interact") and area_detector_shape_1.can_interact():
		var sprite: Sprite2D = area_detector_shape_1.shoes_in_area[0].get_node("Sprite2D")
		juicy_change(sprite, preload("res://assets/Shoes/BrownSneaker.png"))
		
	if Input.is_action_just_pressed("Interact") and area_detector_shape_2.can_interact():
		var sprite: Sprite2D = area_detector_shape_2.shoes_in_area[0].get_node("Sprite2D")
		juicy_change(sprite, preload("res://assets/Shoes/BrownShoe.png"))
		
	if Input.is_action_just_pressed("Interact") and area_detector_color_1.can_interact():
		var shoes: Sprite2D = area_detector_color_1.shoes_in_area[0].get_child(0)
		var file := shoes.texture.resource_path.get_file()
		if "Boot" in file:
			juicy_change(shoes, preload("res://assets/Shoes/RedBoot.png"))
		elif "Sneaker" in file:
			juicy_change(shoes, preload("res://assets/Shoes/RedSneaker.png"))
		elif "Shoe" in file:
			juicy_change(shoes, preload("res://assets/Shoes/RedShoe.png"))
		
	if Input.is_action_just_pressed("Interact") and area_detector_color_2.can_interact():
		var shoes: Sprite2D = area_detector_color_2.shoes_in_area[0].get_child(0)
		var file := shoes.texture.resource_path.get_file()
		if "Boot" in file:
			juicy_change(shoes, preload("res://assets/Shoes/BlueBoot.png"))
		elif "Sneaker" in file:
			juicy_change(shoes, preload("res://assets/Shoes/BlueSneaker.png"))
		elif "Shoe" in file:
			juicy_change(shoes, preload("res://assets/Shoes/BlueShoe.png"))
		
	if Input.is_action_just_pressed("Interact") and area_detector_package_1.can_interact():
		var sprite: Sprite2D = area_detector_package_1.shoes_in_area[0].get_node("Package")
		juicy_change(sprite, preload("res://assets/package_1.png"))
		
	if Input.is_action_just_pressed("Interact") and area_detector_package_2.can_interact():
		var sprite: Sprite2D = area_detector_package_2.shoes_in_area[0].get_node("Package")
		juicy_change(sprite, preload("res://assets/package_2.png"))
	
	move_and_slide()
	
func juicy_change(sprite: Sprite2D, new_texture: Texture2D) -> void:
	# On mémorise l'échelle d'origine une seule fois (évite que l'échelle dérive si on spamme)
	if not sprite.has_meta("base_scale"):
		sprite.set_meta("base_scale", sprite.scale)
	var base: Vector2 = sprite.get_meta("base_scale")
	
	# On coupe l'ancien tween s'il tourne encore
	if sprite.has_meta("juice_tween"):
		var old: Tween = sprite.get_meta("juice_tween")
		if old and old.is_valid():
			old.kill()
	
	# Changement de texture + flash blanc
	sprite.texture = new_texture
	sprite.scale = base
	sprite.modulate = Color(2, 2, 2)
	
	# Tween lié au sprite (se coupe tout seul si la chaussure est supprimée)
	var tween := sprite.create_tween()
	sprite.set_meta("juice_tween", tween)
	
	# 1) Écrasement rapide
	tween.tween_property(sprite, "scale", base * Vector2(1.3, 0.7), 0.08)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	# 2) Rebond élastique vers la taille normale + retour de la couleur
	tween.tween_property(sprite, "scale", base, 0.45)\
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(sprite, "modulate", Color.WHITE, 0.25)
	

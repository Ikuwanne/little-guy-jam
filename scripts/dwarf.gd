extends CharacterBody2D																												

@export var speed = 200
@export var acceleration_speed = 1000
@export var deceleration_speed = 1500
@export var zoom = 1.03
@export var camera: Camera2D

func _physics_process(delta):

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * speed, acceleration_speed * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration_speed * delta)
	
	if Input.is_action_pressed("run"):
		speed = 500
		acceleration_speed = 1400
		if velocity.x > speed * 0.8 or velocity.y > speed * 0.5:
			camera.zoom = camera.zoom.move_toward(Vector2.ONE / zoom, delta/2)
		else :
			camera.zoom = camera.zoom.move_toward(Vector2.ONE, delta/2)
	else :
		camera.zoom = camera.zoom.move_toward(Vector2.ONE, delta/2)
		if speed != 300:
			speed = 300
			acceleration_speed = 1200
	
	move_and_slide()

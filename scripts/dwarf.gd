extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:


	var directionX := Input.get_axis("ui_left", "ui_right")
	var directionY := Input.get_axis("ui_up", "ui_down")
	if directionX or directionY:
		velocity = Vector2(directionX, directionY).normalized() * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

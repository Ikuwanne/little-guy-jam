extends PathFollow2D


@export var speed = 200


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress += delta * speed
	if progress_ratio >= 1.0 and get_child_count() > 0:
		var shoe = get_child(0)
		shoe.queue_free()

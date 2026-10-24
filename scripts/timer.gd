extends Timer

@onready var timer_text: Label = %Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	var minute: int = int(time_left / 60)
	var seconde: int = int(time_left) % 60
	timer_text.text = "%02d:%02d" % [minute, seconde]
	#JE L'AI CODER MOI MEME HEHEHEH
	#J'ai pris 10 min a le faire :') 

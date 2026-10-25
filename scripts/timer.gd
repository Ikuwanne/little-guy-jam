extends Timer

@onready var timer_text: Label = %Timer

@export var warning_time := 30.0
@export var danger_time := 10.0

const COLOR_NORMAL := Color.WHITE
const COLOR_WARNING := Color(0.984, 0.42, 0.114, 1.0)
const COLOR_DANGER := Color("ae2334ff")

# Force du bump à chaque seconde, selon le palier (0 = normal, 1 = attention, 2 = danger)
const BUMP_STRENGTH := [1.04, 1.08, 1.18]

var base_position: Vector2
var last_second := -1
var current_state := 0
var pulse_tween: Tween
var color_tween: Tween

func _ready() -> void:
	base_position = timer_text.position
	timeout.connect(_on_timeout)

func _process(_delta: float) -> void:
	if is_stopped():
		return
	
	var total := ceili(time_left)
	timer_text.text = "%02d:%02d" % [int(total / 60.0), total % 60]
	timer_text.pivot_offset = timer_text.size / 2.0
	
	var state := 0
	if time_left <= danger_time:
		state = 2
	elif time_left <= warning_time:
		state = 1
	
	if state != current_state:
		current_state = state
		_on_state_changed(state)
	
	if total != last_second:
		last_second = total
		_pulse(BUMP_STRENGTH[state])
		GlobalVariables.play_sfx("tick", -20)
	
	if state == 2:
		var intensity := remap(time_left, danger_time, 0.0, 0.5, 3.0)
		timer_text.position = base_position + Vector2(
			randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * intensity
	else:
		timer_text.position = base_position

func _on_state_changed(state: int) -> void:
	var target := COLOR_NORMAL
	if state == 1:
		target = COLOR_WARNING
	elif state == 2:
		target = COLOR_DANGER
	
	if color_tween and color_tween.is_valid():
		color_tween.kill()
	color_tween = create_tween()
	color_tween.tween_property(timer_text, "modulate", target, 0.4)\
		.set_trans(Tween.TRANS_SINE)
	
	# Pop plus marqué quand on entre dans un nouveau palier
	if state > 0:
		_pulse(1.25)

func _pulse(strength: float) -> void:
	if pulse_tween and pulse_tween.is_valid():
		pulse_tween.kill()
	timer_text.scale = Vector2.ONE
	pulse_tween = create_tween()
	pulse_tween.tween_property(timer_text, "scale", Vector2.ONE * strength, 0.08)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	pulse_tween.tween_property(timer_text, "scale", Vector2.ONE, 0.25)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_timeout() -> void:
	timer_text.text = "00:00"
	timer_text.position = base_position
	_pulse(1.5)
	

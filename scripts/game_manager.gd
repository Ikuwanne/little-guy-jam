extends Node2D

@export var score_text: Label

@export var game_finish_panel: Panel
## Le Label du score affiché dans le panneau
@export var final_score_label: Label
@export_range(0.2, 4.0, 0.05) var animation_duration_game_finish := 1.0

var panel_base_position: Vector2
var finished := false

@export_range(0.2, 4.0, 0.05) var animation_duration := 1.0

const COLOR_GAIN := Color("ffb800ff")
const COLOR_LOSS := Color("c3001eff")

var base_position: Vector2
var last_score := 0
var displayed_score := 0
var count_tween: Tween
var pulse_tween: Tween
var color_tween: Tween
var shake_tween: Tween

func _ready() -> void:
	base_position = score_text.position
	last_score = GlobalVariables.score
	displayed_score = last_score
	_update_text(displayed_score)

func _process(_delta: float) -> void:
	score_text.pivot_offset = score_text.size / 2.0
	
	var score: int = GlobalVariables.score
	if score != last_score:
		var gain := score - last_score
		last_score = score
		_on_score_changed(gain)

func _update_text(value: int) -> void:
	displayed_score = value
	score_text.text = "Score : %d" % value

func _on_score_changed(gain: int) -> void:
	if count_tween and count_tween.is_valid():
		count_tween.kill()
	var duration := clampf(0.25 + absf(gain) * 0.002, 0.25, 0.7) * animation_duration
	count_tween = create_tween()
	count_tween.tween_method(
		func(v: float): _update_text(roundi(v)),
		float(displayed_score), float(last_score), duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	if gain > 0:
		_pulse(1.2)
		_flash(COLOR_GAIN)
	else:
		_pulse(0.9)
		_flash(COLOR_LOSS)
		_shake()
	_spawn_floating(gain)

func _pulse(strength: float) -> void:
	if pulse_tween and pulse_tween.is_valid():
		pulse_tween.kill()
	score_text.scale = Vector2.ONE
	pulse_tween = create_tween()
	pulse_tween.tween_property(score_text, "scale", Vector2.ONE * strength, 0.08 * animation_duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	pulse_tween.tween_property(score_text, "scale", Vector2.ONE, 0.25 * animation_duration)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _flash(color: Color) -> void:
	if color_tween and color_tween.is_valid():
		color_tween.kill()
	score_text.modulate = color
	color_tween = create_tween()
	color_tween.tween_property(score_text, "modulate", Color.WHITE, 0.45 * animation_duration)\
		.set_trans(Tween.TRANS_SINE)

func _shake() -> void:
	if shake_tween and shake_tween.is_valid():
		shake_tween.kill()
	shake_tween = create_tween()
	for offset in [6.0, -5.0, 3.0, -2.0, 0.0]:
		shake_tween.tween_property(score_text, "position:x", base_position.x + offset, 0.04 * animation_duration)

func _spawn_floating(gain: int) -> void:
	var floating: Label = score_text.duplicate()
	floating.text = "%+d" % gain
	floating.scale = Vector2.ONE
	floating.modulate = COLOR_GAIN if gain > 0 else COLOR_LOSS
	score_text.get_parent().add_child(floating)
	floating.position = base_position + Vector2(score_text.size.x + 8.0, 0.0)
	
	var t := floating.create_tween().set_parallel(true)
	t.tween_property(floating, "position:y", floating.position.y - 24.0, 0.7 * animation_duration)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_property(floating, "modulate:a", 0.0, 0.7 * animation_duration)\
		.set_delay(0.25 * animation_duration)
	t.chain().tween_callback(floating.queue_free)
func _on_penalty_at_zero() -> void:
	_flash(COLOR_LOSS)
	_pulse(0.92)
	_shake_hard()

func _shake_hard() -> void:
	if shake_tween and shake_tween.is_valid():
		shake_tween.kill()
	score_text.position = base_position
	shake_tween = create_tween()
	var offsets := [
		Vector2(8, -3), Vector2(-7, 3), Vector2(6, -2),
		Vector2(-4, 2), Vector2(2, -1), Vector2.ZERO
	]
	for offset in offsets:
		shake_tween.tween_property(score_text, "position", base_position + offset, 0.035 * animation_duration)
		
	


func _on_timer_timeout() -> void:
	pass # Replace with function body.

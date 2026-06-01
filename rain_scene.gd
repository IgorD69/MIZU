extends Control

@export var rain_shader_rect : ColorRect
@onready var rain_sound_player: AudioStreamPlayer = $AudioStreamPlayer

var speed_min : float = 0.5
var speed_max : float = 7.0
var slant_min : float = -1.0
var slant_max : float = 1.0

var drag_sensitivity_vertical : float = 0.005
var drag_sensitivity_horizontal : float = 0.003

var target_speed : float = 0.5
var target_slant : float = 0.2
var smoothing : float = 2
var pitch_min : float = 0.1
var pitch_max : float = 1.2

var far_length_min : float = 0.01
var far_length_max : float = 0.1

func _ready():
	var material = rain_shader_rect.material as ShaderMaterial
	if material:
		target_speed = material.get_shader_parameter("base_rain_speed")
		target_slant = material.get_shader_parameter("slant")

func _process(_delta):
	var material = rain_shader_rect.material as ShaderMaterial
	if material == null:
		return

	var current_speed = material.get_shader_parameter("base_rain_speed")
	var current_slant = material.get_shader_parameter("slant")
	var current_far_length = material.get_shader_parameter("far_rain_length")

	var new_speed = clamp(lerp(current_speed, target_speed, smoothing), speed_min, speed_max)
	var new_slant = lerp(current_slant, target_slant, smoothing)

	# Din target_slant — valoare fixă, nu se acumulează
	var slant_t = abs(target_slant) / slant_max
	var target_far_length = lerp(far_length_min, far_length_max, slant_t)
	var new_far_length = lerp(current_far_length, target_far_length, smoothing)

	material.set_shader_parameter("base_rain_speed", new_speed)
	material.set_shader_parameter("slant", new_slant)
	material.set_shader_parameter("far_rain_length", new_far_length)

	var t = inverse_lerp(speed_min, speed_max, new_speed)
	rain_sound_player.pitch_scale = lerp(pitch_min, pitch_max, t)

func _input(event):
	if event is InputEventScreenDrag:
		var rel = event.relative
		if abs(rel.y) > abs(rel.x):
			target_speed = clamp(target_speed + rel.y * drag_sensitivity_vertical, speed_min, speed_max)
		else:
			target_slant = clamp(target_slant + rel.x * drag_sensitivity_horizontal, slant_min, slant_max)

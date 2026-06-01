extends Control

@export var rain_shader_rect : ColorRect

var speed_min : float = 0.1
var speed_max : float = 5.0
var slant_min : float = -1.0
var slant_max : float = 1.0

var drag_sensitivity_vertical : float = 0.005
var drag_sensitivity_horizontal : float = 0.003

var target_speed : float = 0.5
var target_additional_speed : float = 0.5
var target_slant : float = 0.2
var smoothing : float = 2

func _ready():
	var material = rain_shader_rect.material as ShaderMaterial
	if material:
		target_speed = material.get_shader_parameter("base_rain_speed")
		target_additional_speed = material.get_shader_parameter("additional_rain_speed")
		target_slant = material.get_shader_parameter("slant")

func _process(_delta):
	var material = rain_shader_rect.material as ShaderMaterial
	if material == null:
		return

	var current_speed = material.get_shader_parameter("base_rain_speed")
	var current_additional_speed = material.get_shader_parameter("additional_rain_speed")
	var current_slant = material.get_shader_parameter("slant")

	material.set_shader_parameter("base_rain_speed",
		clamp(lerp(current_speed, target_speed, smoothing), speed_min, speed_max))
	material.set_shader_parameter("additional_rain_speed",
		clamp(lerp(current_additional_speed, target_additional_speed, smoothing), speed_min, speed_max))
	material.set_shader_parameter("slant",
		lerp(current_slant, target_slant, smoothing))

func _input(event):
	if event is InputEventScreenDrag:
		var rel = event.relative
		if abs(rel.y) > abs(rel.x):
			# swipe jos = mai rapid, swipe sus = mai lent (dar minim 0.1)
			var delta = rel.y * drag_sensitivity_vertical
			target_speed = clamp(target_speed + delta, speed_min, speed_max)
			target_additional_speed = target_speed
		else:
			target_slant = clamp(target_slant + rel.x * drag_sensitivity_horizontal, slant_min, slant_max)

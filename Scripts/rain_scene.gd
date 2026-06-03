extends Control

@export var rain_shader_rect : ColorRect
@onready var bg_gradient: TextureRect = $BG

@onready var rain_sound_player: AudioStreamPlayer = $RainSound

@export var thunder_sound_array: Array[AudioStreamMP3]
@onready var thunder_timer: Timer = $ThunderTimer
@onready var thunder_sound_player: AudioStreamPlayer = $ThunderSoundPlayer

@onready var thunder_freq: HSlider = $MenuButton/Settings_Panel/VBoxContainer4/VBoxContainer/ThunderFreq

var thunder_freq_amount: float = 2
var speed_min : float = 1.0
var speed_max : float = 7.0
var slant_min : float = -1.0
var slant_max : float = 1.0

var rain_amount_min: float = 0.0
var rain_amount_max: float = 400.0

var drag_sensitivity_vertical : float = 0.005
var drag_sensitivity_horizontal : float = 0.003

var drag_sensitivity_rain_amount : float = 0.5 

var volume_min: float = -30.0
var volume_max: float = 0

var pitch_min : float = 0.1
var pitch_max : float = 1.2

var far_length_min : float = 0.05
var far_length_max : float = 0.1

var near_length_min : float = 0.05
var near_length_max : float = 0.1


func _ready():
	var material = rain_shader_rect.material as ShaderMaterial
	if material:
		var current_speed = material.get_shader_parameter("base_rain_speed")
		_update_audio_pitch(current_speed)
		material.set_shader_parameter("far_rain_length", far_length_min)
		material.set_shader_parameter("near_rain_length", near_length_min)

	thunder_timer.timeout.connect(_on_thunder_timer_timeout)
	thunder_timer.start(thunder_freq_amount)

func _on_thunder_timer_timeout() -> void:
	if thunder_sound_array.is_empty():
		return
		
	var random_index = randi() % thunder_sound_array.size()
	var selected_thunder = thunder_sound_array[random_index]
	
	thunder_sound_player.stream = selected_thunder
	thunder_sound_player.play()
	
	
func _input(event):
	if event is InputEventScreenDrag:
		var material = rain_shader_rect.material as ShaderMaterial
		if material == null:
			return
			
		_handle_rain_drag(event, material)
		
		
	if event.is_action("ui_cancel"):
		get_tree().quit()

func _handle_rain_drag(event: InputEventScreenDrag, material: ShaderMaterial) -> void:
	var rel = event.relative
	
	## Vertical Movement
	if abs(rel.y) > abs(rel.x):
		var current_speed = material.get_shader_parameter("base_rain_speed")
		var new_speed = clamp(current_speed + rel.y * drag_sensitivity_vertical, speed_min, speed_max)
		
		var current_amount = material.get_shader_parameter("rain_amount")
		var new_amount = clamp(current_amount + rel.y * drag_sensitivity_rain_amount, rain_amount_min, rain_amount_max)
		
		material.set_shader_parameter("base_rain_speed", new_speed)
		material.set_shader_parameter("rain_amount", new_amount)
		_update_audio_pitch(new_speed)
		
		
	## Horizontal Movement
	else:
		var current_slant = material.get_shader_parameter("slant")
		var new_slant = clamp(current_slant + rel.x * drag_sensitivity_horizontal, slant_min, slant_max)
		
		var slant_t = abs(new_slant) / slant_max
		var new_far_length = lerp(far_length_min, far_length_max, slant_t)
		var new_near_length = lerp(near_length_min, near_length_max, slant_t)
		
		material.set_shader_parameter("slant", new_slant)
		material.set_shader_parameter("far_rain_length", new_far_length)
		material.set_shader_parameter("near_rain_length", new_near_length)


func _update_audio_pitch(speed: float) -> void:
	var t = inverse_lerp(speed_min, speed_max, speed)
	
	rain_sound_player.pitch_scale = lerp(pitch_min, pitch_max, t)
	var new_volume = lerp(volume_min, volume_max, t)
	var master_bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_bus_index, new_volume)
	
	var color_bright = Color(1.0, 1.0, 1.0, 1.0) 
	var color_dark = Color(0.2, 0.2, 0.2, 1.0) 
	
	bg_gradient.modulate = color_bright.lerp(color_dark, t)


func _on_thunder_freq_value_changed(value: float) -> void:
	var min_thunder_time = 3.0 
	var max_thunder_time = 30.0
	
	var time_calc = remap(value, 1.0, 5.0, max_thunder_time, min_thunder_time)
	
	if value == 0:
		thunder_timer.stop()
		return
	thunder_freq_amount = clamp(time_calc, min_thunder_time, max_thunder_time)
	
	thunder_timer.wait_time = thunder_freq_amount
	
	if not thunder_timer.is_stopped():
		thunder_timer.start(thunder_freq_amount)
		

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		thunder_timer.start(thunder_freq_amount)
	else:
		thunder_timer.stop()

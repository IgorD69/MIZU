extends Button

@onready var settings_panel: Panel = $Settings_Panel
@onready var screen_timeout_timer: Timer = $ScreenTimeoutTimer
var panel_tween: Tween


func _ready() -> void:
	toggle_mode = true
	settings_panel.visible = false
	screen_timeout_timer.timeout.connect(_on_screen_timeout_timer_timeout)
	

#func _on_toggled(toggled_on: bool) -> void:
	#settings_panel.visible = toggled_on


func _on_pressed() -> void:
	if panel_tween and panel_tween.is_running():
		panel_tween.kill()
		
	panel_tween = create_tween().set_parallel(true)
	
	if not settings_panel.visible:
		settings_panel.scale = Vector2.ZERO
		settings_panel.modulate.a = 0.0
		settings_panel.visible = true
		
		panel_tween.tween_property(settings_panel, "scale", Vector2.ONE, 0.3)\
			.set_trans(Tween.TRANS_BACK)\
			.set_ease(Tween.EASE_OUT)
			
		panel_tween.tween_property(settings_panel, "modulate:a", 1.0, 0.2)

	else:
		panel_tween.tween_property(settings_panel, "scale", Vector2.ZERO, 0.25)\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_IN)
			
		panel_tween.tween_property(settings_panel, "modulate:a", 0.0, 0.2)
		
		panel_tween.chain().tween_callback(func(): settings_panel.visible = false)
		
		
func seteaza_timp_ecran_aprins(minutes: float) -> void:
	if minutes > 0:
		DisplayServer.screen_set_keep_on(true)
		
		var seconds = minutes * 60.0
		screen_timeout_timer.start(seconds)
		print("Ecranul va rămâne aprins pentru ", minutes, " minute.")
		
	else:
		screen_timeout_timer.stop()
		DisplayServer.screen_set_keep_on(false)

func _on_screen_timeout_timer_timeout() -> void:
	print("Timpul a expirat. Ecranul se poate stinge acum.")
	DisplayServer.screen_set_keep_on(false)


func _process(delta: float) -> void:
	if not screen_timeout_timer.is_stopped():
		var timp_ramas_seconds = screen_timeout_timer.time_left
		var minute_remain = int(timp_ramas_seconds / 60)
		var seconds_remain = int(timp_ramas_seconds) % 60

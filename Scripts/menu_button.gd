extends Button

@onready var settings_panel: Panel = $Settings_Panel
var panel_tween: Tween


func _ready() -> void:
	toggle_mode = true
	settings_panel.visible = false
	


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
		
		

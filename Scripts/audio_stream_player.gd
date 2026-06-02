extends AudioStreamPlayer

func _ready():
	volume_db = -40.0 
	if not playing:
		play()
	
	fade_in(3.0)


func _input(event):
	if event is InputEventScreenTouch and not playing:
		volume_db = -40.0
		play()
		fade_in(3.0)


func fade_in(time: float) -> void:
	var tween = create_tween()
	
	tween.tween_property(self, "volume_db", 0.0, time)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)

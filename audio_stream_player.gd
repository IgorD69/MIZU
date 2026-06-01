extends AudioStreamPlayer

func _ready():
	if not playing:
		play()

func _input(event):
	if event is InputEventScreenTouch and not playing:
		play()

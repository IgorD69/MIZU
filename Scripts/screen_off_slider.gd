extends HSlider

@onready var screen_timeout_timer: Timer = $"../../../../ScreenTimeoutTimer"
@onready var screen_off_time: Label = $"../HBoxContainer/ScreenOFFTime"

func _ready() -> void:
	screen_timeout_timer.timeout.connect(_on_screen_timeout_timer_timeout)

func set_display_off_timer(minutes: float) -> void:
	if minutes > 0:
		DisplayServer.screen_set_keep_on(true)
		
		var seconds = minutes * 60.0
		screen_timeout_timer.start(seconds)
		
	else:
		screen_timeout_timer.stop()
		DisplayServer.screen_set_keep_on(false)

func _on_screen_timeout_timer_timeout() -> void:
	DisplayServer.screen_set_keep_on(false)

func _process(_delta: float) -> void:
	if not screen_timeout_timer.is_stopped():
		var remaining_time = screen_timeout_timer.time_left
		var minutes_remain = int(remaining_time / 60)
		var seconds_remain = int(remaining_time) % 60
		
		screen_off_time.text = "%02d:%02d" % [minutes_remain, seconds_remain]

func _on_value_changed(value: float) -> void:
	if value == 0: screen_off_time.text = "TIME"
	set_display_off_timer(value)

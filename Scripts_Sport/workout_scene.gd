extends Control

@onready var scroll_container: ScrollContainer = $ScrollContainer


var drag_sensitivity_amount = 0.005
var current_amount = 0



#func _ready() -> void:
	#pass
#
#
#
#func _input(event):
	#if event is InputEventScreenDrag:
		#_handle_vertical_drag(event, )
		#
		#
	#if event.is_action("ui_cancel"):
		#get_tree().quit()
#
#func _handle_vertical_drag(event: InputEventScreenDrag) -> void:
	#var rel = event.relative
	#
	### Vertical Movement
	#if abs(rel.y) > abs(rel.x):
		#pass

extends Control

@onready var cards_node: Control = $CardsNode

@onready var main_cards_scene: ScrollContainer = $CardsNode/MainCards
@onready var workout_scene: Control = $CardsNode/WorkoutScene

var drag_sensitivity_amount = 0.005
var current_amount = 0



func _on_workoun_btn_pressed() -> void:
	main_cards_scene.visible = false
	workout_scene.visible = true


func _on_home_btn_pressed() -> void:
	main_cards_scene.visible = true
	workout_scene.visible = false

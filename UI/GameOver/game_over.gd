extends Control

@onready var restart_button = $CanvasLayer/Restart_Buttum
@onready var gomain_button = $CanvasLayer/Gomain_Buttum
@onready var game_over = $CanvasLayer/Game_Over

#@export var game_scene : PackedScene 
#@export var main_scene : PackedScene
@onready var time_label = $CanvasLayer/TimeLabel

func set_final_time(time_string: String) -> void:
	time_label.text = "Time Survived: " + time_string

func _on_restart_buttum_pressed():
	get_tree().change_scene_to_file("res://Scene/game_manager.tscn")
	
func _on_gomain_buttum_pressed():
	get_tree().change_scene_to_file("res://main_scene.tscn")
	

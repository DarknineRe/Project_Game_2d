extends Node2D

@onready var start_button = $CanvasLayer/Start_Button
@onready var exit_button = $CanvasLayer/Exit_Button
@onready var game_name = $CanvasLayer/Game_Name
@export var load_screen : PackedScene

func _ready() -> void:
	AudioManager.main_bgm.play()

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(load_screen)
	AudioManager.main_bgm.stop()


func _on_exit_button_pressed() -> void:
	get_tree().quit()

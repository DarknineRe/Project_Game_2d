extends Control

@onready var restart_button = $CanvasLayer/Restart_Buttum
@onready var gomain_button = $CanvasLayer/Gomain_Buttum
@onready var game_over = $CanvasLayer/Game_Over

@export var game_scene : PackedScene 
@export var main_scene : PackedScene


func _on_restart_buttum_pressed():
	get_tree().change_scene_to_packed(game_scene)

func _on_gomain_buttum_pressed():
	get_tree().change_scene_to_packed(main_scene)

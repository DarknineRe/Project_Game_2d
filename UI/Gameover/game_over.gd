extends Control

@onready var restart_button = $CanvasLayer/Restart_Buttum
@onready var gomain_button = $CanvasLayer/Gomain_Buttum
@onready var game_over = $CanvasLayer/Game_Over
@onready var time_label = $CanvasLayer/TimeLabel
@onready var score_label = $CanvasLayer/ScoreLabel
var final_time: String = ""
var final_score: int = 0

func _ready() -> void:
	get_tree().paused = true

func set_final_results(time_string: String, score: int) -> void:
	final_time = time_string
	final_score = score
	time_label.text = "Time Survived: " + time_string
	score_label.text = "Score: %d" % score

func _on_restart_buttum_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/game_manager.tscn")
	
func _on_gomain_buttum_pressed():
	AudioManager.bgm.stop()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_scene.tscn")

	

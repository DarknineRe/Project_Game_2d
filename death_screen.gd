extends Control

@onready var panel_container: PanelContainer = $PanelContainer
@onready var restart_button: Button = $Restart
@onready var Quit_button: Button = $Quit

var is_paused: bool = false
var paused_by_menu: bool = false  # <--- new flag

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func show_menu() -> void:
	panel_container.show()

func hide_menu() -> void:
	panel_container.hide()

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://main_scene.tscn")

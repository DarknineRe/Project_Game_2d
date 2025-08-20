extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $ColorRect
@onready var panel_container: PanelContainer = $PanelContainer

var is_paused: bool = false

func _ready() -> void:
	animation_player.play("RESET")
	process_mode = Node.PROCESS_MODE_INHERIT
	hide_menu()

func _process(_delta: float) -> void:
	handle_esc_input()

func handle_esc_input() -> void:
	if Input.is_action_just_pressed("esc"):
		toggle_pause()

func toggle_pause() -> void:
	is_paused = !is_paused
	
	if is_paused:
		pause_game()
	else:
		resume_game()

func pause_game() -> void:
	show_menu()
	get_tree().paused = true
	animation_player.play("Blur")

func resume_game() -> void:
	get_tree().paused = false
	animation_player.play_backwards("Blur")
	await animation_player.animation_finished
	hide_menu()

func show_menu() -> void:
	color_rect.show()
	panel_container.show()

func hide_menu() -> void:
	color_rect.hide()
	panel_container.hide()

func _on_resume_pressed() -> void:
	resume_game()

func _on_restart_pressed() -> void:
	resume_game()
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_menu_pressed() -> void:
	pause_game()

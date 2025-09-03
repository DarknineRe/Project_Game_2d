extends Control

func _on_master_volume_2_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(value))

func _on_song_volume_2_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(value))

func _on_sfx_volume_2_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(value))

func _on_check_box_1_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), toggled_on)

func _on_check_box_2_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), toggled_on)

func _on_check_box_3_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), toggled_on)

func _on_close_pressed() -> void:
	hide()

# Convert linear 0-1 slider to dB in Godot 4
func linear2db(value: float) -> float:
	var normalized = clamp(value / 100.0, 0.001, 1.0)
	return 20.0 * log(normalized) / log(10.0)

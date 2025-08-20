extends Control

@onready var upgrade_card_container = $HBoxContainer
@onready var player = get_owner() # adjust path to your Player node!

func _ready() -> void:
	for node in upgrade_card_container.get_children():
		if node is UpgradePanel:
			node.set_player(player)   # give the panel the actual player
			node.upgrade_selected.connect(_on_upgrade_selected)

func _input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		var mouse_position = get_global_mouse_position()
		for node in upgrade_card_container.get_children():
			if node.get_global_rect().has_point(mouse_position):
				node.apply_upgrade()

func _on_upgrade_selected(upgrade: BulletUpgrade) -> void:
	get_tree().paused = false
	print("Upgrade chosen: ", upgrade)
	queue_free()

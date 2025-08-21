extends Control

@export var upgrade_panel_scene: PackedScene
@export var number_of_choices := 3

# Upgrade pools
@export var common_upgrades: Array[BulletUpgrade]
@export var rare_upgrades: Array[BulletUpgrade]
@export var epic_upgrades: Array[BulletUpgrade]
@export var legendary_upgrades: Array[BulletUpgrade]

@onready var upgrade_card_container = $HBoxContainer
@onready var player = get_owner()

# Loot rarity weights
var rarity_table = {
	UpgradePanel.Rarity.COMMON: 60,
	UpgradePanel.Rarity.RARE: 25,
	UpgradePanel.Rarity.EPIC: 10,
	UpgradePanel.Rarity.LEGENDARY: 5
}

func _ready() -> void:
	randomize()
	for i in number_of_choices:
		var panel = upgrade_panel_scene.instantiate() as UpgradePanel
		panel.set_player(player)

		# Roll rarity
		var rolled_rarity = get_random_rarity()
		panel.rarity = rolled_rarity

		# Pick upgrade by rarity
		panel.upgrade = get_upgrade_by_rarity(rolled_rarity)

		# Refresh UI
		panel._ready()

		panel.upgrade_selected.connect(_on_upgrade_selected)
		upgrade_card_container.add_child(panel)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var mouse_position = get_global_mouse_position()
		for node in upgrade_card_container.get_children():
			if node.get_global_rect().has_point(mouse_position):
				node.apply_upgrade()

func _on_upgrade_selected(upgrade: BulletUpgrade) -> void:
	get_tree().paused = false
	print("Upgrade chosen: ", upgrade.description)
	queue_free()

# --- Helpers ---
func get_random_rarity() -> UpgradePanel.Rarity:
	var total_weight = 0
	for w in rarity_table.values():
		total_weight += w
	
	var roll = randi_range(1, total_weight)
	var cumulative = 0
	
	for rarity in rarity_table.keys():
		cumulative += rarity_table[rarity]
		if roll <= cumulative:
			return rarity
	
	return UpgradePanel.Rarity.COMMON

func get_upgrade_by_rarity(rarity: UpgradePanel.Rarity) -> BulletUpgrade:
	match rarity:
		UpgradePanel.Rarity.COMMON:
			return common_upgrades.pick_random()
		UpgradePanel.Rarity.RARE:
			return rare_upgrades.pick_random()
		UpgradePanel.Rarity.EPIC:
			return epic_upgrades.pick_random()
		UpgradePanel.Rarity.LEGENDARY:
			return legendary_upgrades.pick_random()
		_:
			return common_upgrades.pick_random()

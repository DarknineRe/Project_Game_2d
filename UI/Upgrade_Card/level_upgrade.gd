extends Control

@export var upgrade_panel_scene: PackedScene
@export var number_of_choices := 3
signal upgrade_chosen(upgrade: Resource)

# Bullet Upgrade pools
@export var common_bullet_upgrades: Array[BulletUpgrade]
@export var rare_bullet_upgrades: Array[BulletUpgrade]
@export var epic_bullet_upgrades: Array[BulletUpgrade]
@export var legendary_bullet_upgrades: Array[BulletUpgrade]

# Player Upgrade pools
@export var common_player_upgrades: Array[PlayerUpgrade]
@export var rare_player_upgrades: Array[PlayerUpgrade]
@export var epic_player_upgrades: Array[PlayerUpgrade]
@export var legendary_player_upgrades: Array[PlayerUpgrade]

@onready var upgrade_card_container = $HBoxContainer
@onready var player = get_owner()

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

		# Decide randomly between Bullet or Player upgrade
		if randi_range(0, 1) == 0:
			panel.upgrade_type = UpgradePanel.UpgradeType.BULLET
			panel.upgrade = get_upgrade_by_rarity(rolled_rarity, true)
		else:
			panel.upgrade_type = UpgradePanel.UpgradeType.PLAYER
			panel.upgrade = get_upgrade_by_rarity(rolled_rarity, false)

		panel._ready()
		panel.upgrade_selected.connect(_on_upgrade_selected)
		upgrade_card_container.add_child(panel)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var mouse_position = get_global_mouse_position()
		for node in upgrade_card_container.get_children():
			if node.get_global_rect().has_point(mouse_position):
				node.apply_upgrade()

func _on_upgrade_selected(upgrade: Resource) -> void:
	emit_signal("upgrade_chosen", upgrade)
	if upgrade and upgrade is PlayerUpgrade:
		print("Upgrade chosen (Player): ", upgrade.description)
	elif upgrade and upgrade is BulletUpgrade:
		print("Upgrade chosen (Bullet): ", upgrade.description)
	else:
		print("Upgrade chosen: unknown type")
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

func get_upgrade_by_rarity(rarity: UpgradePanel.Rarity, is_bullet: bool) -> Resource:
	if is_bullet:
		match rarity:
			UpgradePanel.Rarity.COMMON:
				return common_bullet_upgrades.pick_random()
			UpgradePanel.Rarity.RARE:
				return rare_bullet_upgrades.pick_random()
			UpgradePanel.Rarity.EPIC:
				return epic_bullet_upgrades.pick_random()
			UpgradePanel.Rarity.LEGENDARY:
				return legendary_bullet_upgrades.pick_random()
	else:
		match rarity:
			UpgradePanel.Rarity.COMMON:
				return common_player_upgrades.pick_random()
			UpgradePanel.Rarity.RARE:
				return rare_player_upgrades.pick_random()
			UpgradePanel.Rarity.EPIC:
				return epic_player_upgrades.pick_random()
			UpgradePanel.Rarity.LEGENDARY:
				return legendary_player_upgrades.pick_random()

	# fallback return
	return null

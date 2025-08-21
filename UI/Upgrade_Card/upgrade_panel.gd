extends Panel
class_name UpgradePanel

signal upgrade_selected(upgrade: BulletUpgrade)

enum Rarity { COMMON, RARE, EPIC, LEGENDARY }

@export var upgrade: BulletUpgrade
@export var rarity: Rarity = Rarity.COMMON

@onready var texture = $VBoxContainer/MarginContainer/TextureRect
@onready var label = $VBoxContainer/MarginContainer2/Label

var player: CharacterBody2D = null

var rarity_colors := {
	Rarity.COMMON: Color.WHITE,
	Rarity.RARE: Color.SKY_BLUE,
	Rarity.EPIC: Color.MEDIUM_PURPLE,
	Rarity.LEGENDARY: Color.GOLD
}

func _ready() -> void:
	if upgrade:
		texture.texture = upgrade.texture
		label.text = upgrade.description
	else:
		texture.texture = null
		label.text = "No Upgrade"

	label.add_theme_color_override("font_color", rarity_colors[rarity])

func set_player(p: CharacterBody2D) -> void:
	player = p
func _physics_process(_delta: float) -> void:
	if player == null: 
		player = get_tree().get_first_node_in_group("Player") 
		if player == null: 
			return # No player found
func apply_upgrade():
	if player:
		player.upgrades.append(upgrade)
		upgrade_selected.emit(upgrade)
	else:
		push_error("UpgradePanel: Player not set before apply_upgrade()")

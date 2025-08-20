class_name UpgradePanel
extends Panel

signal upgrade_selected

@export var icon: Texture2D
@export var description: String
@export var upgrade: BulletUpgrade
@onready var texture = $VBoxContainer/MarginContainer/TextureRect
@onready var label = $VBoxContainer/MarginContainer2/Label
var player : CharacterBody2D = null

func _ready() -> void:
	texture.texture = icon
	label.text = description

func _physics_process(_delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
		if player == null:
			return  # No player found
			
func set_player(p: Player) -> void:
	player = p

func apply_upgrade():
	if player:
		player.upgrades.append(upgrade)
		upgrade_selected.emit(upgrade)
	else:
		push_error("UpgradePanel: Player not set before apply_upgrade()")

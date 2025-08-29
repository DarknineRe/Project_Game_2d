extends Resource
class_name PlayerUpgrade

@export var texture: Texture2D
@export var description: String = "No description"

@export var upgrade_type: String = "health"  # "health", "speed", "sprint_multiplier", "dash_multiplier", "stamina", "dash_cost"
@export var amount: float = 10.0

func apply_upgrade(_player):
	pass

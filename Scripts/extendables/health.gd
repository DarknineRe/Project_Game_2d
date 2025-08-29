extends Node
class_name Health

signal health_changed(health: float)

@export var max_health := 100.0
@export_group("Link Node")
@export var hitbox : Hitbox

@onready var health := max_health
@onready var unit = get_owner()

func on_damaged(attack: Attack):
	if not unit.alive:
		return
	
	health -= attack.damage
	health_changed.emit(health)
	
	if health <= 0:
		health = 0
		unit.alive = false

# -----------------------------
# Upgrade function
# -----------------------------
func increase_max_health(amount: float, heal: bool = true) -> void:
	max_health += amount
	if heal:
		health += amount
	health_changed.emit(health)

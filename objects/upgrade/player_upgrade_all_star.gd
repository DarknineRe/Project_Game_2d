extends PlayerUpgrade
class_name PlayerUpgradeAllStar

@export var health_add: float = 0.0
@export var health_mult: float = 1.0
@export var speed_add: float = 0.0
@export var speed_mult: float = 1.0
@export var sprint_mult_add: float = 0.0
@export var sprint_mult_mult: float = 1.0
@export var dash_mult_add: float = 0.0
@export var dash_mult_mult: float = 1.0
@export var stamina_add: float = 0.0
@export var stamina_mult: float = 1.0
@export var dash_cost_add: float = 0.0
@export var dash_cost_mult: float = 1.0

func apply_upgrade(player):
	if not player:
		print("Doest do anything")
		return

	# Health (these emit both signals for the bar)
	if health_add != 0.0:
		player.health_node.increase_max_health(health_add)
	if health_mult != 1.0:
		player.health_node.multiply_max_health(health_mult)

	player.movement.increase_speed(speed_add)
	player.movement.increase_sprint_multiplier(sprint_mult_add)
	player.movement.increase_dash_multiplier(dash_mult_add)
	player.movement.increase_max_stamina(stamina_add)
	player.movement.reduce_dash_stamina_cost(dash_cost_add)

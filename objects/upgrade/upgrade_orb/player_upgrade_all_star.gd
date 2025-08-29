extends PlayerUpgrade
class_name PlayerUpgradeAllStar

# Health
@export var health_add: float = 0
@export var health_mult: float = 1

# Speed
@export var speed_add: float = 0
@export var speed_mult: float = 1

# Sprint multiplier
@export var sprint_mult_add: float = 0
@export var sprint_mult_mult: float = 1

# Dash multiplier
@export var dash_mult_add: float = 0
@export var dash_mult_mult: float = 1

# Stamina
@export var stamina_add: float = 0
@export var stamina_mult: float = 1

# Dash cost reduction
@export var dash_cost_add: float = 0
@export var dash_cost_mult: float = 1

func apply_upgrade(player):
	if not player:
		return

	# Health
	player.health_node.increase_max_health(health_add)
	player.health_node.max_health *= health_mult

	# Speed
	player.movement.increase_speed(speed_add)
	player.movement.speed *= speed_mult

	# Sprint multiplier
	player.movement.increase_sprint_multiplier(sprint_mult_add)
	player.movement.sprint_multiplier *= sprint_mult_mult

	# Dash multiplier
	player.movement.increase_dash_multiplier(dash_mult_add)
	player.movement.dash_multiplier *= dash_mult_mult

	# Stamina
	player.movement.increase_max_stamina(stamina_add)
	player.movement.max_stamina *= stamina_mult

	# Dash cost
	player.movement.reduce_dash_stamina_cost(dash_cost_add)
	player.movement.dash_cost *= dash_cost_mult

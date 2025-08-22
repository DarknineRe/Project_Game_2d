extends BulletUpgrade
class_name BulletUpgradeAllStar

@export var damage_mult: float = 1
@export var damage_add: float = 0

@export var speed_add: float = 0
@export var speed_mult: float = 1

@export var lifetime_add: float = 0

@export var crit_chance_add: float = 0
@export var crit_chance_mult: float = 1

@export var crit_mult_add: float = 0
@export var crit_mult_mult: float = 1

@export var max_pierce_add: int = 0

@export var fire_rate_add: float = 0
@export var fire_rate_mult: float = 1

func apply_upgrade(bullet):
	bullet.damage += damage_add
	bullet.damage *= damage_mult
	bullet.crit_chance += crit_chance_add
	bullet.crit_chance *= crit_chance_mult
	bullet.speed += speed_add
	bullet.speed *= speed_mult
	bullet.crit_mult += crit_mult_add
	bullet.crit_mult *= crit_mult_mult
	bullet.fire_rate += fire_rate_add
	bullet.fire_rate *= fire_rate_mult
	bullet.max_pierce += max_pierce_add
	bullet.lifetime += lifetime_add

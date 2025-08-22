extends BulletUpgrade
class_name BulletUpgradeDamage

@export var damage_mult: float = 1
@export var damage_add: float = 0

func apply_upgrade(bullet):
	bullet.damage += damage_add
	bullet.damage *= damage_mult

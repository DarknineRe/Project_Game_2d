extends BulletUpgrade
class_name BulletUpgradeSpeed

@export var speed_add: float = 0
@export var speed_mult: float = 1

func apply_upgrade(bullet):
	bullet.speed += speed_add
	bullet.speed *= speed_mult
	print("New bullet speed: ", bullet.speed)

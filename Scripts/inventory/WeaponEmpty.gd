extends Weapon

class_name WeaponEmpty

func _init():
	name = "Empty"
	texture = null  # ไม่มี sprite
	damage = 0
	crit_chance = 0.0
	crit_mult = 1.0
